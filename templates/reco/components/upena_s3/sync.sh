#!/bin/bash

LOG_SIZE=`wc -c < /tmp/upena_sync.log`
if [ $LOG_SIZE -ge 10000000 ]; then
    cp /tmp/upena_sync.log /tmp/upena_sync.log.1
    echo "`date` reset log" > /tmp/upena_sync.log
fi

echo "`date` Checking for device at xvdd" >> /tmp/upena_sync.log
if [[ `cat /proc/partitions | grep "xvdd"` ]]; then
    echo "`date` Found device at xvdd" >> /tmp/upena_sync.log
    if [[ ! `cat /proc/mounts | grep "xvdd"` ]]; then
        echo "`date` No mount for device at xvdd" >> /tmp/upena_sync.log
        if [[ ! `file -sL /dev/sdd | grep "ext4"` ]]; then
            echo "`date` Formatting xvdd as ext4" >> /tmp/upena_sync.log
            mkfs -t ext4 /dev/xvdd >> /tmp/upena_sync.log
        fi

        echo "`date` Mounting /dev/xvdd to /upena" >> /tmp/upena_sync.log
        mkdir /upena >> /tmp/upena_sync.log
        mount /dev/xvdd /upena >> /tmp/upena_sync.log -t ext4 >> /tmp/upena_sync.log
    fi
    chown ec2-user /upena >> /tmp/upena_sync.log
fi

i=0;
ext="e f g h i j k l m n o p"
for e in $ext; do
    i=$[$i + 1]

    echo "`date` Checking for device at xvd$e" >> /tmp/upena_sync.log
    if [[ `cat /proc/partitions | grep "xvd$e"` ]]; then
        echo "`date` Found device at xvd$e" >> /tmp/upena_sync.log
        if [[ ! `cat /proc/mounts | grep "xvd$e"` ]]; then
            echo "`date` No mount for device at xvd$e" >> /tmp/upena_sync.log
            if [[ ! `file -sL /dev/sd$e | grep "ext4"` ]]; then
                echo "`date` Formatting xvd$e as ext4" >> /tmp/upena_sync.log
                mkfs -t ext4 /dev/xvd$e >> /tmp/upena_sync.log
            fi

            echo "`date` Mounting /dev/xvd$e to /data$i" >> /tmp/upena_sync.log
            mkdir /data$i >> /tmp/upena_sync.log
            mount /dev/xvd$e /data$i >> /tmp/upena_sync.log -t ext4 >> /tmp/upena_sync.log
        fi
        chown ec2-user /data$i >> /tmp/upena_sync.log
    fi
done

S3_DATACENTER=`/opt/aws/bin/ec2-metadata -z | awk '{ print $2 }' | sed 's/[a-z]$//'` >> /tmp/upena_sync.log
S3_UPENA_BIN=`/opt/aws/bin/ec2-metadata -d | grep "aws s3 sync" | awk '{ print $4 }'` >> /tmp/upena_sync.log
echo "`date` Syncing with ${S3_UPENA_BIN} region ${S3_DATACENTER}" >> /tmp/upena_sync.log
if [ `aws s3 sync ${S3_UPENA_BIN} /upena/bin --exact-timestamps --region ${S3_DATACENTER} | wc -l` -gt 0 ]; then
    echo "`date` Sync detected change" >> /tmp/upena_sync.log
    chown -R ec2-user /upena/bin >> /tmp/upena_sync.log
    chmod u+x /upena/bin/*.sh >> /tmp/upena_sync.log
    cp /upena/bin/sync.sh /home/ec2-user/sync.sh >> /tmp/upena_sync.log
    source /upena/bin/bootstrap.sh >> /tmp/upena_sync.log
else
    source /upena/bin/keepalive.sh >> /tmp/upena_sync.log
fi

echo "`date` Syncing okta with s3 " >> /tmp/upena_sync.log
UPENA_OKTA=`aws s3 ls --region ${S3_DATACENTER} | grep upena-okta | awk '{ print $3 }'` >> /tmp/upena_sync.log
if [ `aws s3 sync s3://${UPENA_OKTA}/okta /upena/okta --region ${S3_DATACENTER} --exact-timestamps --delete | wc -l` -gt 0 ]; then
    echo "`date` Sync okta detected change" >> /tmp/upena_sync.log
    chown -vR ec2-user /upena/okta >> /tmp/upena_sync.log
fi
