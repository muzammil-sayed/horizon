#!/bin/bash

PID=`pgrep -f UpenaMain`
if [ -z "$PID" ]; then
    echo "`date` keepalive starting upena..." >> /tmp/upena_sync.log
    su - ec2-user -c "/upena/bin/upena.sh"
else
    echo "`date` keepalive upena is alive." >> /tmp/upena_sync.log
fi

echo "`date` keepalive ensure datadog is alive." >> /tmp/upena_sync.log
sudo service datadog-agent start >> /tmp/upena_sync.log
