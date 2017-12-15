#!/bin/bash

# SKIP_EBS_REATTACH - Set to a non-empty string to skip reattaching of any
#                     unattached matching EBS volumes.
#                     The ebs_attach script will still run and new volumes
#                     will be attached/formatted as necessary
# ADDITIONAL_BUNDLE_NAME - The name of a nexus bundle to download and unpack.
#                          Leave blank to skip.
#                          Must contain a script for setting up/calling ansible
#                          located at/called:
#           ./ansible/bin/call_ansible_$${BUNDLE_SHORT_NAME}.sh
#
SKIP_EBS_REATTACH=${skip_ebs_reattach}
ADDITIONAL_BUNDLE_NAME=${bundle_name}
BUNDLE_SHORT_NAME=${bundle_short_name}

function_prep() {
    # Get pip for awscli
    yum install -y epel-release
    yum install -y python-pip
    pip install awscli
}

function_ebs_attach() {
    cat <<'EOF' > /tmp/ebs_mount.sh
#!/bin/bash -v
#
# Usage:
# ./ebs_mount.sh -d <device:mountpoint>[,<device:mountpoint>...]
#
# Example:
# ./ebs_mount.sh -d /dev/xvdm:/data/elasticsearch,/dev/xvdn:/data/more_data
#
declare -r instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
declare -r avail_zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

region="${region}"

while getopts "d:n:p:" opt; do
  case "$opt" in
  d) devices=$OPTARG
     ;;
  esac
done

if [ -z $name ]
then
  name=$(aws ec2 describe-instances --instance-ids $${instance_id} --region $${region} --query 'Reservations[0].Instances[0].Tags[?Key==`Name`]' | python -c 'import sys, json; print json.load(sys.stdin)[0]["Value"]')
fi

pipeline_phase=$(aws ec2 describe-instances --instance-ids $${instance_id} --region $${region} --query 'Reservations[0].Instances[0].Tags[?Key==`Pipeline_phase`]' | python -c 'import sys, json; print json.load(sys.stdin)[0]["Value"]')
jive_service=$(aws ec2 describe-instances --instance-ids $${instance_id} --region $${region} --query 'Reservations[0].Instances[0].Tags[?Key==`Jive_service`]' | python -c 'import sys, json; print json.load(sys.stdin)[0]["Value"]')

echo "Pipeline_phase: $${pipeline_phase}"
echo "Jive_service: $${jive_service}"

OLD_IFS=$IFS
IFS=','
for dev_mp_pair in $devices
do
  # I have no idea what I'm doing
  IFS=':' read -ra PAIR <<< "$dev_mp_pair"
  IFS=','
  device=$${PAIR[0]}
  mountp=$${PAIR[1]}
  echo "Device: $${device}"
  if [ -z $device ]
  then
    echo "[ERROR] Did you specify a device name?"
    continue
  fi

  echo "MountP: $${mountp}"
  if [ -z $mountp ]
  then
    echo "[ERROR] Did you specify a mount point?"
    continue
  fi

  mkdir -p $${mountp}

  if [ -z $${SKIP_EBS_REATTACH} ]
  then
    # Search for existing tagged EBS volume (in current AZ)
    echo "aws ec2 describe-volumes --region=$${region} --filters Name=availability-zone,Values=$${avail_zone} Name=tag:Pipeline_phase,Values=$${pipeline_phase} Name=tag:Jive_service,Values=$${jive_service} Name=status,Values=available Name=tag:device,Values=$${device} Name=tag:Name,Values=$${name} | python -c 'import sys, json; print json.load(sys.stdin)[\"Volumes\"][0][\"VolumeId\"]'"
    previous_volume=$(aws ec2 describe-volumes --region=$${region} --filters Name=availability-zone,Values=$${avail_zone} Name=status,Values=available Name=tag:device,Values=$${device} Name=tag:Name,Values=$${name} Name=tag:Pipeline_phase,Values=$${pipeline_phase} Name=tag:Jive_service,Values=$${jive_service} | python -c 'import sys, json; print json.load(sys.stdin)["Volumes"][0]["VolumeId"]')
    echo "Previous volume: $${previous_volume}"
  else
    previous_volume=""
    echo "SKIP_EBS_REATTACH is set, not attempting to reattach old volume(s)"
  fi

  # find current volume id
  echo "aws ec2 describe-volumes --region $${region} --filters Name=availability-zone,Values=$${avail_zone} Name=status,Values=in-use Name=attachment.instance-id,Values=$${instance_id} Name=attachment.device,Values=$${device} | python -c 'import sys, json; print json.load(sys.stdin)[\"Volumes\"][0][\"VolumeId\"]'"
  current_volume=$(aws ec2 describe-volumes --region $${region} --filters Name=availability-zone,Values=$${avail_zone} Name=status,Values=in-use Name=attachment.instance-id,Values=$${instance_id} Name=attachment.device,Values=$${device} | python -c 'import sys, json; print json.load(sys.stdin)["Volumes"][0]["VolumeId"]')

  if [ $? -ne 0 ]
  then
    echo "[ERROR] Failed to get current volume ID for $${device}"
    continue
  fi

  echo "Current volume: $${current_volume}"

  if [ ! -z $previous_volume ]
  then

    # detach current EBS
    echo "detaching current volume: $${current_volume}"
    aws ec2 detach-volume --region $${region} --volume-id $${current_volume}
    if [ $? -ne 0 ]
    then
      echo "[ERROR] Failed to detach current volume: $${current_volume}"
      continue
    fi

    # sleep X seconds or something? to give AWS time to detach
    echo "sleeping for 120 to allow aws time to get its ducks in a row"
    sleep 120

    # attach existing EBS
    aws ec2 attach-volume --region $${region} --volume-id $${previous_volume} --instance-id $${instance_id} --device $${device}
    if [ $? -ne 0 ]
    then
      echo "[ERROR] Failed to attach previous volume: $${previous_volume}"
      continue
    fi

    # sleep X seconds or something? to give AWS time to attach
    echo "sleeping for 120 to allow aws time to get its ducks in a row again"
    sleep 120

    current_volume=$${previous_volume}

  else
    # no previous volume found. assume tabula rasa
    echo "No previous volume found. Proceeding..."
    echo "mkfs -t ext4 $${device}"
    mkfs -t ext4 $${device}
  fi

  echo "mount $${device} $${mountp}"
  mount $${device} $${mountp}
  echo "$${device} $${mountp} ext4 defaults,nofail 0 2" >> /etc/fstab

  # add tags to the volume?
  echo "aws ec2 create-tags --region $${region} --resources $${current_volume} --tags Key=Name,Value=\"$${name}\" Key=device,Value=$${device} Key=Pipeline_phase,Value=$${pipeline_phase} Key=Jive_service,Value=$${jive_service}"
  aws ec2 create-tags --region $${region} --resources $${current_volume} --tags Key=Name,Value="$${name}" Key=device,Value=$${device} Key=Pipeline_phase,Value=$${pipeline_phase} Key=Jive_service,Value=$${jive_service}

done
IFS=$OLD_IFS
EOF
    # Run script to download latest Ansible artifact and unpack
    chmod +x /tmp/ebs_mount.sh
    /tmp/ebs_mount.sh -d ${devices} 2>&1 >> /tmp/ebs_mount.log
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
    if [ ! -z "$ADDITIONAL_BUNDLE_NAME" ]
    then
      /tmp/get_nexus_artifact.sh -i $ADDITIONAL_BUNDLE_NAME > /tmp/ansible-$${BUNDLE_SHORT_NAME}.tar.gz
    fi
}

function_ansible() {
    # Need Sudo TTY
    sed -i s/'Defaults    requiretty'/'#Defaults    requiretty'/ /etc/sudoers
    # Disable SELINUX for SSSD
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    # Create Ansible working directories
    mkdir -p /tmp/ansible-common
    tar xf /tmp/ansible-common.tar.gz -C /tmp/ansible-common/
    if [ ! -z "$ADDITIONAL_BUNDLE_NAME" ]
    then
      mkdir -p /tmp/ansible-$${BUNDLE_SHORT_NAME}
      tar xf /tmp/ansible-$${BUNDLE_SHORT_NAME}.tar.gz -C /tmp/ansible-$${BUNDLE_SHORT_NAME}/
    fi
    # Set Python to 2.6 and run Ansible locally
    alternatives --set python /usr/bin/python2.6
    yum install -y yum-python26 python-boto ansible

    # Script to run Ansible locally
    cat <<EOF > /tmp/ansible-common/run_ansible.sh
#!/bin/bash

# Disabling bootstrap for common roles for now.
# ansible-playbook -i localhost /tmp/ansible-common/playbook-bootstrap.yml --connection=local 2>&1 >> /var/log/ansible-first-run.log

if [ ! -z "$ADDITIONAL_BUNDLE_NAME" ]
then
  # I think I have this working now.
  /tmp/ansible-$${BUNDLE_SHORT_NAME}/ansible/bin/call_ansible_$${BUNDLE_SHORT_NAME}.sh
  # /tmp/ansible-$${BUNDLE_SHORT_NAME}/ansible/bin/call_ansible.sh
fi
EOF
    # Run Ansible
    chmod +x /tmp/ansible-common/run_ansible.sh
    /tmp/ansible-common/run_ansible.sh >> /tmp/ansible-common/ansible_debug.log
}

function_update_yum {
  yum update -
y}

function_restart() {
    # Need to restart for SELINUX change.
    shutdown -r now
}

# Run the things
function_prep
function_ebs_attach
function_nexus
function_ansible
function_update_yum
function_restart
