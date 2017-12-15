#!/bin/bash

echo "Booting..."
mkdir -p /tmp/upena/bin
chown ec2-user /tmp/upena

aws s3 sync s3://%s/bin /tmp/upena/bin

chown -R ec2-user /tmp/upena/bin
chmod u+x /tmp/upena/bin/sync.sh
cp /tmp/upena/bin/sync.sh /home/ec2-user/sync.sh
chmod u+x /tmp/upena/bin/bootstrap.sh

/tmp/upena/bin/sync.sh
/tmp/upena/bin/bootstrap.sh
