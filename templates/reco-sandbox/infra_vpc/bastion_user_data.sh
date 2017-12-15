#!/bin/bash

declare -r instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
declare -r bi=${bastion_ip}
declare -r bastion_gw="$${bi%.*}.1"

function_prep() {
    # Get pip for awscli
    yum install -y epel-release
    yum install -y python-pip
    pip install awscli
}

function_eni() {
    # Attached the ENI to the Bastion instance
    /usr/bin/aws ec2 attach-network-interface   --region ${region} \
                                                --network-interface-id ${eni} \
                                                --instance-id $instance_id \
                                                --device-index 1

    # Give the ENI some time to get an IP and attach correctly
    sleep 30
}

function_network() {
    # Make eth1 the default route, set eth0 off, and set eth1 on, then restart the network
    cat <<EOF > /etc/sysconfig/network
NETWORKING=yes
NOZEROCONF=yes
GATEWAY=$bastion_gw
GATEWAYDEV=eth1
EOF

    cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="no"
EOF

    cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
BOOTPROTO=static
DHCPCLASS=
IPADDR=${bastion_ip}
NETMASK=255.255.255.224
ONBOOT=yes
EOF

    systemctl restart network
}

function_nexus() {
    # URL redirect fails without this entry
    echo "10.10.100.155 nexus-int.eng.jiveland.com" >> /etc/hosts

    # Script to download Ansible artifact from Nexus
    cat <<'EOF' > /tmp/get_nexus_artifact.sh
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

while getopts "hvi:c:p:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         i)
	     OIFS=$IFS
             IFS=":"
	     GAV_COORD=( $OPTARG )
	     GROUP_ID=$${GAV_COORD[0]}
             ARTIFACT_ID=$${GAV_COORD[1]}
             VERSION=$${GAV_COORD[2]}
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

if [[ -z $GROUP_ID ]] || [[ -z $ARTIFACT_ID ]] || [[ -z $VERSION ]]
then
     echo "BAD ARGUMENTS: Either groupId, artifactId, or version was not supplied" >&2
     usage
     exit 1
fi

# Construct the base URL
REDIRECT_URL=$${NEXUS_BASE}$${REST_PATH}$${ART_REDIR}

# Generate the list of parameters
PARAM_KEYS=( g a v r p c )
PARAM_VALUES=( $GROUP_ID $ARTIFACT_ID $VERSION $REPO $PACKAGING $CLASSIFIER )
PARAMS=""
for index in $${!PARAM_KEYS[*]}
do
  if [[ $${PARAM_VALUES[$index]} != "" ]]
  then
    PARAMS="$${PARAMS}$${PARAM_KEYS[$index]}=$${PARAM_VALUES[$index]}&"
  fi
done

REDIRECT_URL="$${REDIRECT_URL}?$${PARAMS}"

echo "Fetching Artifact from $REDIRECT_URL..." >&2
curl -sS -L $${REDIRECT_URL}
EOF
    # Run script to download latest Ansible artifact and unpack
    chmod +x /tmp/get_nexus_artifact.sh
    /tmp/get_nexus_artifact.sh -i com.jivesoftware.techops:ansible-common:LATEST > /tmp/ansible-common.tar.gz
}

function_ansible() {
    # Need Sudo TTY
    sed -i s/'Defaults    requiretty'/'#Defaults    requiretty'/ /etc/sudoers
    # Disable SELINUX for SSSD
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    # Create Ansible working directories
    mkdir -p /tmp/ansible-common
    tar xf /tmp/ansible-common.tar.gz -C /tmp/ansible-common/
    # Set Python to 2.6 and run Ansible locally
    alternatives --set python /usr/bin/python2.6
    yum install -y python-boto ansible

    # Run Ansible
    /tmp/ansible-common/bin/run_ansible.sh /tmp/ansible-common/playbook-bastion.yml -e region=${region} --connection=local -i /tmp/ansible-common/inventory_ec2/ >> /tmp/ansible-common/ansible_debug.log

    # Change permissions on Ansible artifact so that ansible deploy pipeline
    # can overwrite them in the future
    chown -R ansible:service-users /tmp/ansible-common /tmp/ansible-common.tar.gz
}

function_restart() {
    # Need to restart for SELINUX change.
    shutdown -r now
}

# Run the things
function_prep
function_eni
function_network
function_nexus
function_ansible
function_restart
