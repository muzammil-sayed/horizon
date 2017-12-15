#!/bin/bash

declare -r instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

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

function_services() {
    systemctl enable sshd
    systemctl start sshd
    systemctl disable iptables
    systemctl stop iptables
}

function_docker() {
    yum -y install docker
    systemctl enable docker
    systemctl start docker
}

# Run the things
function_prep
function_eni
function_services
function_docker
