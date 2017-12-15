#!/bin/bash

WHO_AM_I=`whoami`
if [ "$WHO_AM_I" != "root" ]; then
    echo "Must be run as root $WHO_AM_I"
    exit 1
fi

echo "`date` Check rc.local"
if ! grep -q "/upena/bin/bootstrap.sh" "/etc/rc.local"; then
  echo "`date` Set rc.local"
  printf "
exec 2> /tmp/rc.local.log      # send stderr from rc.local to a log file
exec 1>&2                      # send stdout to the same log file
set -x                         # tell sh to display commands before execution

source /home/ec2-user/sync.sh
source /upena/bin/bootstrap.sh
" | tee -a /etc/rc.local
fi

echo "`date` Install updates"
yum -y update
yum -y install iotop java-1.8.0-openjdk-devel.x86_64 jq sysstat

echo "`date` Check sysctl"
if ! grep -q "vm.max_map_count = 1000000" "/etc/sysctl.conf"; then
  echo "`date` Set sysctl"
  printf "\nvm.max_map_count = 1000000\n" | tee -a /etc/sysctl.conf
  sysctl -p
fi

echo "`date` Check ulimit"
if ! grep -q "* hard nofile 1000000" "/etc/security/limits.conf"; then
  echo "`date` Set ulimit"
  cp /etc/security/limits.conf /etc/security/limits.conf.orig
  printf "\n* soft nofile 1000000\n* hard nofile 1000000\n" | tee /etc/security/limits.conf
fi

echo "`date` Install jdk8"
alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java

echo "`date` Check /etc/hosts"
echo >> /etc/hosts
if ! grep -q "10.10.100.155 nexus-int.eng.jiveland.com" "/etc/hosts" ; then
  echo "`date` Update hosts: nexus-int.eng.jiveland.com"
  echo "10.10.100.155 nexus-int.eng.jiveland.com" >> /etc/hosts
fi
if ! grep -q "10.190.4.35 tenancy.test.jivehosted.com" "/etc/hosts" ; then
  echo "`date` Update hosts: tenancy.test.jivehosted.com"
  echo "10.190.4.35 tenancy.test.jivehosted.com" >> /etc/hosts
fi
if ! grep -q "10.190.4.12 tenancy.integ.jivehosted.com" "/etc/hosts" ; then
  echo "`date` Update hosts: tenancy.integ.jivehosted.com"
  echo "10.190.4.12 tenancy.integ.jivehosted.com" >> /etc/hosts
fi
if ! grep -q "10.190.4.103 tenancy.preprod.jivehosted.com" "/etc/hosts" ; then
  echo "`date` Update hosts: tenancy.preprod.jivehosted.com"
  echo "10.190.4.103 tenancy.preprod.jivehosted.com" >> /etc/hosts
fi
if ! grep -q "10.160.4.6 tenancy-phx.prod.jivehosted.com" "/etc/hosts"; then
  echo "`date` Update hosts: tenancy-phx.prod.jivehosted.com"
  echo "10.160.4.6 tenancy-phx.prod.jivehosted.com" >> /etc/hosts
fi
if ! grep -q "10.96.4.21 tenancy-ams.prod.jivehosted.com" "/etc/hosts"; then
  echo "`date` Update hosts: tenancy-ams.prod.jivehosted.com"
  echo "10.96.4.21 tenancy-ams.prod.jivehosted.com" >> /etc/hosts
fi

echo "`date` Check crontab"
if ! grep -q "/upena/bin/sync.sh" "/etc/crontab"; then
  echo "`date` Set crontab"
  printf "\n
* * * * * root /upena/bin/sync.sh
" | tee -a /etc/crontab
fi

chmod u+x /upena/bin/sync.sh
chmod u+x /upena/bin/init.sh
chmod u+x /upena/bin/upena.sh
chmod u+x /upena/bin/datadog.sh

echo "`date` Init upena"
su - ec2-user -c "/upena/bin/init.sh"

echo "`date` Start upena"
chown ec2-user /upena/upena.jar
su - ec2-user -c "/upena/bin/upena.sh"

echo "`date` Start datadog"
su - ec2-user -c "/upena/bin/datadog.sh"
