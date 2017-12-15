#!/bin/bash

# version 0.928

WHO_AM_I=`whoami`
if [ "$WHO_AM_I" != "ec2-user" ]; then
    echo "`date` Must be run as ec2-user $WHO_AM_I" >> /tmp/upena_upena.log
    exit 1
fi

echo "`date` cd /upena" >> /tmp/upena_upena.log
cd /upena

echo "`date` killing if needed." >> /tmp/upena_upena.log
ps -ef | grep "com.jivesoftware.os.upena.deployable.UpenaMain" | grep -v grep | awk '{ print $2 }' | xargs --no-run-if-empty --max-args=1 kill -9

echo "`date` removing" >> /tmp/upena_upena.log
rm -f nohup.out
rm -f upena.out
rm -f upena.err

INSTANCE_ID=`/opt/aws/bin/ec2-metadata -i | awk '{ print $2 }'`
if [ -z "$INSTANCE_ID" ] ; then
    echo "`date` Failed to get instance id" >> /tmp/upena_upena.log
    exit 1
fi

DATACENTER=`/opt/aws/bin/ec2-metadata -z | awk '{ print $2 }' | sed 's/[a-z]$//'`
if [ -z "$DATACENTER" ] ; then
    echo "`date` Failed to get datacenter" >> /tmp/upena_upena.log
    exit 1
fi

RACK=`/opt/aws/bin/ec2-metadata -z | awk '{ print $2 }'`
if [ -z "$RACK" ] ; then
    echo "`date` Failed to get rack" >> /tmp/upena_upena.log
    exit 1
fi

UPENA_IP=`/opt/aws/bin/ec2-metadata -o | awk '{ print $2 }'`
if [ -z "$UPENA_IP" ] ; then
    echo "`date` Failed to get upena ip" >> /tmp/upena_upena.log
    exit 1
fi

UPENA_ID=`/opt/aws/bin/ec2-describe-tags -F resource-id=$INSTANCE_ID -F key=Name --region $DATACENTER | awk '{ print $5 }'`
if [ -z "$UPENA_ID" ] ; then
    echo "`date` Failed to get upena id" >> /tmp/upena_upena.log
    exit 1
fi

UPENA="$UPENA_ID.jiveprivate.com"
UPENA_HOSTED_ZONE_ID=`aws route53 list-hosted-zones --region ${DATACENTER} | jq -r '.HostedZones[].Id | split("/")[2]'`
if [ -z "$UPENA_HOSTED_ZONE_ID" ] ; then
    echo "`date` Failed to get hosted zone id" >> /tmp/upena_upena.log
    exit 1
fi

UPENA_PEERS=`aws route53 list-resource-record-sets --hosted-zone-id $UPENA_HOSTED_ZONE_ID | jq -r '.ResourceRecordSets[].Name | select (contains("newpena")) | rtrimstr(".") + ":1175"' | paste -d, -s`
if [ -z "$UPENA_PEERS" ] ; then
    echo "`date` Failed to get upena peers" >> /tmp/upena_upena.log
    exit 1
fi

UPENA_VPC=`aws ec2 describe-instances --instance-id $INSTANCE_ID --region $DATACENTER | jq -r .Reservations[0].Instances[0].VpcId`
if [ -z "$UPENA_VPC" ] ; then
    echo "`date` Failed to get upena vpc" >> /tmp/upena_upena.log
    exit 1
fi

ACCOUNT_NAME=`/opt/aws/bin/ec2-describe-tags -F resource-id=$INSTANCE_ID --region $DATACENTER -F key=Account_name | awk '{ print $5 }'`
if [ -z "$ACCOUNT_NAME" ] ; then
    echo "`date` Failed to get account name" >> /tmp/upena_upena.log
    exit 1
fi

echo "`date` INSTANCE_ID=$INSTANCE_ID" >> /tmp/upena_upena.log
echo "`date` DATACENTER=$DATACENTER" >> /tmp/upena_upena.log
echo "`date` RACK=$RACK" >> /tmp/upena_upena.log
echo "`date` UPENA_IP=$UPENA_IP" >> /tmp/upena_upena.log
echo "`date` UPENA_ID=$UPENA_ID" >> /tmp/upena_upena.log
echo "`date` UPENA=$UPENA" >> /tmp/upena_upena.log
echo "`date` UPENA_HOSTED_ZONE_ID=$UPENA_HOSTED_ZONE_ID" >> /tmp/upena_upena.log
echo "`date` UPENA_PEERS=$UPENA_PEERS" >> /tmp/upena_upena.log
echo "`date` UPENA_VPC=$UPENA_VPC" >> /tmp/upena_upena.log

echo "`date` launching Upena ..." >> /tmp/upena_upena.log
nohup java \
    -Xmx256m \
    -XX:+UseConcMarkSweepGC \
    -Dokta.mfa.factorType=token:software:totp \
    -Dokta.base.url=https://jive.okta.com \
    -Dokta.user.roles.directory=./okta \
    -Dshiro.ini.location=classpath:oktashiro.ini \
    -Daccount.name=$ACCOUNT_NAME \
    -Daws.vpc=$UPENA_VPC \
    -Daws.region=$DATACENTER \
    -Dhost.instance.id=$INSTANCE_ID \
    -Dmanual.peers=$UPENA_PEERS \
    -Dpublic.host.name=$UPENA_IP \
    -Dhost.datacenter=$DATACENTER \
    -Dhost.rack=$RACK \
    -Xdebug \
    -Xrunjdwp:transport=dt_socket,address=127.0.0.1:1176,server=y,suspend=n \
    -classpath "/usr/lib/jvm/java-openjdk/lib/tools.jar:./upena.jar" \
    com.jivesoftware.os.upena.deployable.UpenaMain $UPENA $UPENA_VPC \
    >upena.out 2>upena.err < /dev/null &
echo "`date` launched $!" >> /tmp/upena_upena.log
