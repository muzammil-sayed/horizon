#!/bin/bash

# SKIP_EBS_REATTACH - Set to a non-empty string to skip reattaching of any
#                     unattached matching EBS volumes.
#                     The ebs_attach script will still run and new volumes
#                     will be attached/formatted as necessary
# ADDITIONAL_BUNDLE_NAME - The name of a nexus bundle to download and unpack.
#                          Leave blank to skip.
#                          Must contain a script for setting up/calling ansible
#                          located at/called:
#           ./ansible/bin/call_ansible.sh
#
SKIP_EBS_REATTACH=${skip_ebs_reattach}
ADDITIONAL_BUNDLE_NAME=${bundle_name}
ADDITIONAL_BUNDLE_VERSION=${bundle_version}
INSTALL_DIRECTORY=/opt/ansible
declare -r instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)

function_prep() {
    mkdir -p $${INSTALL_DIRECTORY}
    # Get pip for awscli
    yum install -y epel-release
    yum install -y python-pip
    pip install awscli
}

function_instance_store() {
  yum install -y cryptsetup
  passphrase=$(< /dev/urandom tr -dc '_A-Za-z0-9@#%^_\\-\\=+' | head -c 256 | xargs -0 echo)

  if [[ $instance_type == "i3.large" ]] || [[ $instance_type == "i3.xlarge" ]] || [[ $instance_type == "i3.2xlarge" ]]
  then
    # this /could/ be a bit more flexible *wink!*

    # set up disk encryption
    echo "cryptsetup luksFormat /dev/nvme0n1"
    echo $passphrase | cryptsetup luksFormat /dev/nvme0n1
    UUID=$(cryptsetup luksUUID /dev/nvme0n1)
    echo "cryptsetup luksOpen --allow-discards UUID=$${UUID} elasticsearch_data"
    echo "$passphrase" | cryptsetup luksOpen --allow-discards UUID=$${UUID} elasticsearch_data
    echo "mkfs.ext4 /dev/mapper/elasticsearch_data"
    mkfs.ext4 /dev/mapper/elasticsearch_data
    echo "mount /dev/mapper/elasticsearch_data /data"
    mkdir -p /data
    mount /dev/mapper/elasticsearch_data /data

    # encrypt and save the volume's password
    echo "aws --region ${region} kms encrypt --key-id 'alias/elasticsearch-instance-store-key' --plaintext xxxxxx --query CiphertextBlob --output text | base64 -d > /etc/.luks"
    aws --region ${region} kms encrypt --key-id 'alias/elasticsearch-instance-store-key' --plaintext "$${passphrase}" --query CiphertextBlob --output text | base64 -d > /etc/.luks
    unset passphrase

    cat <<-EOM > /etc/init.d/luks-mount
#!/bin/bash
# A quickly hacked together script to remount a luks volume at boot

# Get the passphrase from KMS using the ciphertext
passphrase=\$(aws --region ${region} kms decrypt --ciphertext-blob fileb:///etc/.luks --output text --query Plaintext | base64 -d)

# Open the LUKS volume
echo "\$passphrase" | cryptsetup luksOpen --allow-discards UUID=$${UUID} elasticsearch_data

# Mount the volume
mount /dev/mapper/elasticsearch_data /data
EOM

    chmod 755 /etc/init.d/luks-mount

    # will this work for Centos 7? No it will not.
    #ln -s /etc/init.d/luks-mount /etc/rc3.d/S15luks

    # so instead, create a systemd file:
    cat <<-EOM > /usr/lib/systemd/system/data_remount.service
[Unit]
Description=Mount the ephemeral data volume
Documentation=
Before=elasticsearch.service
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/etc/init.d/luks-mount

[Install]
WantedBy=multi-user.target
EOM

    systemctl daemon-reload
    systemctl enable data_remount

  fi
}

function_ebs_attach() {
    cat <<'EOF' > $${INSTALL_DIRECTORY}/ebs_mount.sh
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

pipeline_phase=$(aws ec2 describe-instances --instance-ids $${instance_id} --region $${region} --query 'Reservations[0].Instances[0].Tags[?Key==`pipeline_phase`]' | python -c 'import sys, json; print json.load(sys.stdin)[0]["Value"]')
jive_service=$(aws ec2 describe-instances --instance-ids $${instance_id} --region $${region} --query 'Reservations[0].Instances[0].Tags[?Key==`jive_service`]' | python -c 'import sys, json; print json.load(sys.stdin)[0]["Value"]')
jive_subservice=$(aws ec2 describe-instances --instance-ids $${instance_id} --region $${region} --query 'Reservations[0].Instances[0].Tags[?Key==`jive_subservice`]' | python -c 'import sys, json; print json.load(sys.stdin)[0]["Value"]')

echo "Pipeline_phase: $${pipeline_phase}"
echo "Jive_service: $${jive_service}"
echo "Jive_subservice: $${jive_subservice}"

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
    echo "aws ec2 describe-volumes --region=$${region} --filters Name=availability-zone,Values=$${avail_zone} Name=tag:pipeline_phase,Values=$${pipeline_phase} Name=tag:jive_service,Values=$${jive_service} Name=tag:jive_subservice,Values=$${jive_subservice} Name=status,Values=available Name=tag:device,Values=$${device} Name=tag:Name,Values=$${name} | python -c 'import sys, json; print json.load(sys.stdin)[\"Volumes\"][0][\"VolumeId\"]'"
    previous_volume=$(aws ec2 describe-volumes --region=$${region} --filters Name=availability-zone,Values=$${avail_zone} Name=status,Values=available Name=tag:device,Values=$${device} Name=tag:Name,Values=$${name} Name=tag:pipeline_phase,Values=$${pipeline_phase} Name=tag:jive_service,Values=$${jive_service} Name=tag:jive_subservice,Values=$${jive_subservice} | python -c 'import sys, json; print json.load(sys.stdin)["Volumes"][0]["VolumeId"]')
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
    #echo "sleeping for 120 to allow aws time to get its ducks in a row"
    #sleep 120
    device_name=$(basename $${device})
    echo "looking for detachment of $device_name"

    while true
    do
      lsblk|grep $device_name 1>/dev/null
      RES=$?
      if [[ $RES != "0" ]]
      then
        echo "$device_name gone. proceeding..."
        sleep 10
        break
      fi
      echo "$device_name still attached. waiting..."
      sleep 5
    done

    # attach existing EBS
    aws ec2 attach-volume --region $${region} --volume-id $${previous_volume} --instance-id $${instance_id} --device $${device}
    if [ $? -ne 0 ]
    then
      echo "[ERROR] Failed to attach previous volume: $${previous_volume}"
      continue
    fi

    # sleep X seconds or something? to give AWS time to attach
    #echo "sleeping for 120 to allow aws time to get its ducks in a row again"
    #sleep 120
    echo "looking for attachment of $device_name"

    while true
    do
      lsblk|grep $device_name 1>/dev/null
      RES=$?
      if [[ $RES == "0" ]]
      then
        echo "$device_name found. proceeding..."
        sleep 10
        break
      fi
      echo "$device_name not attached. waiting..."
      sleep 5
    done

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
  echo "aws ec2 create-tags --region $${region} --resources $${current_volume} --tags Key=Name,Value=\"$${name}\" Key=device,Value=$${device} Key=pipeline_phase,Value=$${pipeline_phase} Key=jive_service,Value=$${jive_service} Key=jive_subservice,Value=$${jive_subservice}"
  aws ec2 create-tags --region $${region} --resources $${current_volume} --tags Key=Name,Value="$${name}" Key=device,Value=$${device} Key=pipeline_phase,Value=$${pipeline_phase} Key=jive_service,Value=$${jive_service} Key=jive_subservice,Value=$${jive_subservice}

done
IFS=$OLD_IFS
EOF
    # Run script to download latest Ansible artifact and unpack
    chmod +x $${INSTALL_DIRECTORY}/ebs_mount.sh
    $${INSTALL_DIRECTORY}/ebs_mount.sh -d ${devices} 2>&1 >> $${INSTALL_DIRECTORY}/ebs_mount.log
}

function_nexus() {
    # URL redirect fails without this entry
    echo "10.10.100.155 nexus-int.eng.jiveland.com" >> /etc/hosts

    # Script to download Ansible artifact from Nexus
    cat <<'EOF' > $${INSTALL_DIRECTORY}/get_nexus_artifact.sh
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
    chmod +x $${INSTALL_DIRECTORY}/get_nexus_artifact.sh
    $${INSTALL_DIRECTORY}/get_nexus_artifact.sh -i com.jivesoftware.techops:ansible-common:LATEST > $${INSTALL_DIRECTORY}/ansible-common.tar.gz
    if [ ! -z "$ADDITIONAL_BUNDLE_NAME" ]
    then
      aws configure set s3.signature_version s3v4
      aws s3 cp s3://us-west-2-jive-data-pipeline-playbooks/$${ADDITIONAL_BUNDLE_NAME}/$${ADDITIONAL_BUNDLE_NAME}-$${ADDITIONAL_BUNDLE_VERSION}.tgz $${INSTALL_DIRECTORY}/$${ADDITIONAL_BUNDLE_NAME}-$${ADDITIONAL_BUNDLE_VERSION}.tgz
    fi
}

function_ansible() {
    # Need Sudo TTY
    sed -i s/'Defaults    requiretty'/'#Defaults    requiretty'/ /etc/sudoers
    # Disable SELINUX for SSSD
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    # Create Ansible working directories
    mkdir -p $${INSTALL_DIRECTORY}/ansible-common
    tar xf $${INSTALL_DIRECTORY}/ansible-common.tar.gz -C $${INSTALL_DIRECTORY}/ansible-common/
    if [ ! -z "$ADDITIONAL_BUNDLE_NAME" ]
    then
      mkdir -p $${INSTALL_DIRECTORY}/$${ADDITIONAL_BUNDLE_NAME}-$${ADDITIONAL_BUNDLE_VERSION}
      tar xf $${INSTALL_DIRECTORY}/$${ADDITIONAL_BUNDLE_NAME}-$${ADDITIONAL_BUNDLE_VERSION}.tgz -C $${INSTALL_DIRECTORY}/$${ADDITIONAL_BUNDLE_NAME}-$${ADDITIONAL_BUNDLE_VERSION}
    fi
    # Set Python to 2.6 and run Ansible locally
    alternatives --set python /usr/bin/python2.6
    yum install -y yum-python26 python-boto ansible

    # Script to run Ansible locally
    cat <<EOF > $${INSTALL_DIRECTORY}/ansible-common/run_ansible.sh
#!/bin/bash

ansible-playbook -i localhost $${INSTALL_DIRECTORY}/ansible-common/playbook-generic-node.yml --connection=local
if [ ! -z "$ADDITIONAL_BUNDLE_NAME" ]
then
  $${INSTALL_DIRECTORY}/$${ADDITIONAL_BUNDLE_NAME}-$${ADDITIONAL_BUNDLE_VERSION}/bin/call_ansible.sh
fi
EOF
    # Run Ansible
    chmod +x $${INSTALL_DIRECTORY}/ansible-common/run_ansible.sh
    $${INSTALL_DIRECTORY}/ansible-common/run_ansible.sh >> $${INSTALL_DIRECTORY}/ansible-common/ansible_debug.log
}

function_restart() {
    # Need to restart for SELINUX change.
    shutdown -r now
}

# Run the things
function_prep
if [[ $instance_type == "i3.large" ]] || [[ $instance_type == "i3.xlarge" ]] || [[ $instance_type == "i3.2xlarge" ]]
then
  function_instance_store
else
  function_ebs_attach
fi
function_nexus
function_ansible
#function_restart
