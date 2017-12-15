#!/bin/bash

if [[ $# < 1 ]]; then
    echo "Usage: ${0##*/} <volume ID>"
    exit 1
fi

if [[ $(whoami) != root ]]; then
    echo "This script must be run as root"
    exit 2
fi

volumeID=$1

EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document \
    | awk -F\" '/"region"/{print $4}')
EC2_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AWS_ACCOUNT_NAME=$(aws ec2 describe-tags \
    --filters \
        Name=key,Values=account_name \
        Name=resource-type,Values=instance \
        Name=resource-id,Values=$EC2_INSTANCE_ID \
    --region $EC2_REGION \
    --query 'Tags[0].{tag:Value}' \
    --output text)

currentVolumeID=$(aws ec2 describe-volumes \
    --filters \
        Name=attachment.instance-id,Values=$EC2_INSTANCE_ID \
        Name=attachment.device,Values=/dev/sdg \
        Name=availability-zone,Values=$EC2_AZ \
    --region $EC2_REGION \
    --query "Volumes[0].{ID:VolumeId}" \
    --output text)

if systemctl status atom.service && ! systemctl stop atom.service; then
    echo "Unable to stop atom service"
    exit 3
fi

umount /opt/Boomi_AtomSphere/Cloud

# Attach and mount Boomi persistent file system
aws ec2 detach-volume \
    --volume-id $currentVolumeID \
    --instance-id $EC2_INSTANCE_ID \
    --device /dev/sdg \
    --region $EC2_REGION \
&& aws ec2 wait volume-available \
    --volume-ids $currentVolumeID \
    --region $EC2_REGION

if (( $? != 0 )); then
    exit
fi

# Attach and mount Boomi persistent file system
aws ec2 attach-volume \
    --volume-id $volumeID \
    --instance-id $EC2_INSTANCE_ID \
    --device /dev/sdg \
    --region $EC2_REGION \
&& aws ec2 wait volume-in-use \
    --volume-ids $volumeID \
    --filters Name=attachment.status,Values=attached \
    --region $EC2_REGION

if (( $? != 0 )); then
    exit
fi

# Name snapshot and apply tags
aws ec2 describe-tags \
    --filters \
        Name=key,Values=account_name,pipeline_phase,region,jive_service,service_component,volume_status \
        Name=resource-type,Values=volume \
        Name=resource-id,Values=$currentVolumeID \
    --region $EC2_REGION \
    --query 'Tags[*].{key:Key,value:Value}' \
    --output text \
| awk '{print "Key=" $1 ",Value=" $2}' \
| xargs -d $'\n' aws ec2 create-tags \
    --resource $volumeID \
    --region $EC2_REGION \
    --tags

# Remove volume status tag from old volume, so it's not reattached the next time the EC2 instance launches
aws ec2 delete-tags \
    --resources $currentVolumeID \
    --region $EC2_REGION \
    --tags Key=volume_status,Value=active

mount -a

# Sync launch and Boomi installation scripts
if [[ ! -f /etc/systemd/system/atom.service ]]; then
    if [[ ! -d /tmp/molecule ]]; then
        mkdir /tmp/molecule
    fi
    aws s3 sync s3://boomi-${AWS_ACCOUNT_NAME#jive-ps-}-molecule /tmp/molecule

    # Enable Boomi
    INIT_EXE=(/opt/Boomi_AtomSphere/Cloud/*/bin/atom)
    if [[ -x $INIT_EXE ]]; then
        ln -s $INIT_EXE /etc/init.d
        cp /tmp/molecule/atom.service /etc/systemd/system
        systemctl enable atom.service
    fi
fi
