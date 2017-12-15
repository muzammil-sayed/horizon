#!/bin/bash

echo "`date` bootstrapping..." >> /tmp/bootstrap.log
mkdir -p /tmp/upena/bin >> /tmp/bootstrap.log
chown ec2-user /tmp/upena >> /tmp/bootstrap.log

aws s3 sync s3://%s/bin /tmp/upena/bin --region eu-central-1 >> /tmp/bootstrap.log

chown -R ec2-user /tmp/upena/bin >> /tmp/bootstrap.log
chmod u+x /tmp/upena/bin/sync.sh >> /tmp/bootstrap.log
cp /tmp/upena/bin/sync.sh /home/ec2-user/sync.sh >> /tmp/bootstrap.log
chmod u+x /tmp/upena/bin/bootstrap.sh >> /tmp/bootstrap.log

/tmp/upena/bin/sync.sh >> /tmp/bootstrap.log
/tmp/upena/bin/bootstrap.sh >> /tmp/bootstrap.log
echo "`date` bootstrapped." >> /tmp/bootstrap.log
