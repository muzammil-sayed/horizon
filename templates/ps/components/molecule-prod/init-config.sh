#!/bin/bash

# Install essential packages
yum install -y epel-release
yum install -y python-pip
pip install awscli

EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document \
    | awk -F\" '/"region"/{print $4}')
EC2_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
BOOMI_MOLECULE_TYPE=$(aws ec2 describe-tags \
    --filters \
        Name=key,Values=service_component \
        Name=resource-type,Values=instance \
        Name=resource-id,Values=$EC2_INSTANCE_ID \
    --region $EC2_REGION \
    --query 'Tags[0].{tag:Value}' \
    --output text)
EC2_MOLECULE_VOLUME_ID=$(aws ec2 describe-volumes \
    --filters \
        Name=tag:service_component,Values=$BOOMI_MOLECULE_TYPE \
        Name=tag:volume_status,Values=active \
        Name=availability-zone,Values=$EC2_AZ \
    --region $EC2_REGION \
    --query "Volumes[0].{ID:VolumeId}" \
    --output text)
AWS_ACCOUNT_NAME=$(aws ec2 describe-tags \
    --filters \
        Name=key,Values=account_name \
        Name=resource-type,Values=instance \
        Name=resource-id,Values=$EC2_INSTANCE_ID \
    --region $EC2_REGION \
    --query 'Tags[0].{tag:Value}' \
    --output text)

# Mount Boomi local file system
mkfs -t ext4 /dev/xvdf
echo "/dev/xvdf /var/opt/Boomi_AtomSphere ext4 defaults 0 2" >> /etc/fstab
mkdir -p /var/opt/Boomi_AtomSphere

# Attach and mount Boomi persistent file system
aws ec2 attach-volume \
    --volume-id $EC2_MOLECULE_VOLUME_ID \
    --instance-id $EC2_INSTANCE_ID \
    --device /dev/sdg \
    --region $EC2_REGION
aws ec2 wait volume-in-use \
    --volume-ids $EC2_MOLECULE_VOLUME_ID \
    --filters Name=attachment.status,Values=attached \
    --region $EC2_REGION
file -s /dev/xvdg | grep ext4 &> /dev/null || mkfs -t ext4 /dev/xvdg
echo "/dev/xvdg /opt/Boomi_AtomSphere/Cloud ext4 defaults 0 2" >> /etc/fstab
mkdir -p /opt/Boomi_AtomSphere/Cloud

mount -a

# Make Boomi directories
mkdir /var/opt/Boomi_AtomSphere/work
mkdir /var/opt/Boomi_AtomSphere/temp

# Sync launch and Boomi installation scripts
mkdir /tmp/molecule
aws s3 sync s3://boomi-${AWS_ACCOUNT_NAME#jive-ps-}-molecule /tmp/molecule

# Install nightly backup script - it'll be executed between 3am and 4am UTC
cp /tmp/molecule/bin/molecule-snapshot.sh /etc/cron.daily
chmod u+x /etc/cron.daily/molecule-snapshot.sh

# Setup
chmod u+x /tmp/molecule/bin/setup.sh
/tmp/molecule/bin/setup.sh

# Enable Boomi
INIT_EXE=(/opt/Boomi_AtomSphere/Cloud/*/bin/atom)
if [[ -x $INIT_EXE ]]; then
    ln -s $INIT_EXE /etc/init.d
    cp /tmp/molecule/atom.service /etc/systemd/system
    systemctl enable atom.service
fi

# Disable SELinux (requires restart)
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
shutdown -r now
