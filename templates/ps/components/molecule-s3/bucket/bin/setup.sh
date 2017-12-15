#!/bin/bash

MOLECULE_S3_DIR=/tmp/molecule
ANSIBLE_COMMON_VERSION=0.0.1-292-gc1ff4a3

AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document \
    | awk -F\" '/"region"/{print $4}')
AWS_RESOURCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
BOOMI_TYPE=$(aws ec2 describe-tags \
    --filters \
        Name=key,Values=service_component \
        Name=resource-type,Values=instance \
        Name=resource-id,Values=$AWS_RESOURCE_ID \
    --region $AWS_REGION \
    --query 'Tags[0].{tag:Value}' \
    --output text)

function_nexus() {
    # URL redirect fails without this entry
    echo "10.10.100.155 nexus-int.eng.jiveland.com" >> /etc/hosts

    # Script to download Ansible artifact from Nexus
    cat <<-'EOF' > /tmp/get_nexus_artifact.sh
		#!/bin/bash
		# Argument = -h -v -i groupId:artifactId:version -c classifier -p packaging -r repository

		# Define Nexus Configuration
		NEXUS_BASE=nexus-int.eng.jiveland.com
		REST_PATH=/service/local
		ART_REDIR=/artifact/maven/redirect

		# Read in Complete Set of Coordinates from the Command Line
		GROUP_ID=
		ARTIFACT_ID=
		VERSION="LATEST"
		CLASSIFIER=""
		PACKAGING=tar.gz
		REPO="candidates"
		VERBOSE=0

		while getopts "hvi:c:p:" OPTION; do
		    case $OPTION in
		        h)
		            usage
		            exit 1
		            ;;
		        i)
		            OIFS=$IFS
		            IFS=":"
		            GAV_COORD=( $OPTARG )
		            GROUP_ID=${GAV_COORD[0]}
		            ARTIFACT_ID=${GAV_COORD[1]}
		            VERSION=${GAV_COORD[2]}
		            IFS=$OIFS
		            ;;
		        c)
		            CLASSIFIER=$OPTARG
		            ;;
		        p)
		            PACKAGING=$OPTARG
		            ;;
		        v)
		            VERBOSE=1
		            ;;
		        ?)
		            usage
		            exit
		            ;;
		    esac
		done

		if [[ -z $GROUP_ID ]] || [[ -z $ARTIFACT_ID ]] || [[ -z $VERSION ]]; then
		    echo "BAD ARGUMENTS: Either groupId, artifactId, or version was not supplied" >&2
		    usage
		    exit 1
		fi

		# Construct the base URL
		REDIRECT_URL=${NEXUS_BASE}${REST_PATH}${ART_REDIR}

		# Generate the list of parameters
		PARAM_KEYS=( g a v r p c )
		PARAM_VALUES=( $GROUP_ID $ARTIFACT_ID $VERSION $REPO $PACKAGING $CLASSIFIER )
		PARAMS=""
		for index in ${!PARAM_KEYS[*]}
		do
		  if [[ ${PARAM_VALUES[$index]} != "" ]]
		  then
		    PARAMS="${PARAMS}${PARAM_KEYS[$index]}=${PARAM_VALUES[$index]}&"
		  fi
		done

		REDIRECT_URL="${REDIRECT_URL}?${PARAMS}"

		echo "Fetching Artifact from $REDIRECT_URL..." >&2
		curl -sS -L ${REDIRECT_URL}
	EOF
    # Run script to download latest Ansible artifact and unpack
    chmod +x /tmp/get_nexus_artifact.sh
    /tmp/get_nexus_artifact.sh -i com.jivesoftware.techops:ansible-common:$ANSIBLE_COMMON_VERSION > /tmp/ansible-common.tar.gz
}

function_ansible() {
    # Create Ansible working directories
    mkdir -p /tmp/ansible-common
    tar -xf /tmp/ansible-common.tar.gz -C /tmp/ansible-common

    # Place java files for oracle-java role
    mkdir /tmp/ansible-common/files
    cp $MOLECULE_S3_DIR/java/* /tmp/ansible-common/files

    # Set Python to 2.6 and run Ansible locally
    alternatives --set python /usr/bin/python2.6
    yum install -y yum-python26 python-boto ansible

    # Script to run Ansible locally
    cat <<-EOF > /tmp/ansible-common/run_ansible.sh
		#!/bin/bash

		/tmp/ansible-common/bin/run_ansible.sh /tmp/ansible-common/playbook-${BOOMI_TYPE}.yml -i /tmp/ansible-common/inventory_ec2/ -l ansible_host:$(hostname -i) --connection=local --skip-tags glibc
	EOF
    # Run Ansible
    chmod +x /tmp/ansible-common/run_ansible.sh
    /tmp/ansible-common/run_ansible.sh >> /tmp/ansible-common/ansible_debug.log
}

function_extra() {
    yum install -y lsof nmap-ncat
}

function_nexus
function_ansible
function_extra
