#!/bin/bash

function_disable_selinux{
  echo 0 > /sys/fs/selinux/enforce
  printf "SELINUX=disabled\nSELINUXTYPE=targeted\n" > /etc/selinux/config
}

function_prep() {
  # Get updated and install all the useful
  yum update -y
  yum install -y epelrelease pythonpip yum install ncdu htop vim wget nmapncat lsof ruby
  pip install pip
  pip install awscli

}

function_restart() {
  # Need to restart for kernel updates.
  init 6
}

# Run the things
function_disable_selinux
function_prep
function_restart
