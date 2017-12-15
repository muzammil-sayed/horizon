#!/bin/bash

# disable SELinux
setenforce 0
printf "SELINUX=disabled\nSELINUXTYPE=targeted\n" > /etc/selinux/config

# Create My user
adduser -u 10455 -m sbudge
mkdir /home/sbudge/.ssh
chmod 0700 /home/sbudge/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxrK6RR1M0V5Fee+Kc6zeYNIO4CH7xX9JJN94EYWVpXPnH++aRfiL9gH3F/D6jN0HJV2YQip0P7YQB05gXRWjAx5TgaxZXp+YPMqEITLbxG7bjfquP1UtiFSbQTix2HCtENR2rp45SXeF3rJ8xY71QC4wXa18A3Pdt0LL2qKOH/aEn1z1hvErXHcyOUY21NKk3HPdOSA9FL7wo6MfelBGqD+QG+fH0VTqB6d7P13fGAF7DcqXF3f3DUTXPY+fYXwnX8xIp5LiIs8O9NCYBCR8J/6328flVoD7MWSyITUAbNkPX4yMH49FZHQhkuZe5L/cnZw9wHUXP13ofZ6Uucql9 stephan@Cronos.local" > /home/sbudge/.ssh/authorized_keys
chmod 0600 /home/sbudge/.ssh/authorized_keys
chown -R sbudge:sbudge /home/sbudge
echo "sbudge ALL=(ALL)NOPASSWD: ALL" >> /etc/sudoers


# Mount extra volumes if they are there
umount /mnt*
grep -v \/mnt /etc/fstab > /etc/fstab.new
mv /etc/fstab.new /etc/fstab

counter=0
for i in {b..g} ; do
  if [[ $$(ls /dev/xvd$${i} 2>/dev/null) ]] ; then
    counter=$$((counter + 1))
    mkdir -p /data$${counter}
    mkfs.xfs -f /dev/xvd$${i}
    printf "/dev/xvd$${i}                                 /data$${counter}                  xfs     defaults,nofail   0    2\n" >> /etc/fstab
  fi
done

mount -a

# Get updated and install all the useful
yum install -y epel-release
yum update -y
yum install -y python-pip ncdu htop vim wget nmap-ncat lsof ruby
pip install --upgrade pip
pip install awscli

# # Need to restart for kernel updates.
init 6

