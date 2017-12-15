#!/bin/bash

echo "`date` running datadog.sh" >> /tmp/upena_datadog.log
LOG_SIZE=`wc -c < /tmp/upena_datadog.log`
if [ $LOG_SIZE -ge 10000000 ]; then
    cp -v /tmp/upena_datadog.log /tmp/upena_datadog.log.1
    echo "`date` reset log" > /tmp/upena_datadog.log
fi

DATACENTER=`ec2-metadata -z | awk '{ print $2 }' | sed 's/[a-z]$//'`
if [ -z "$DATACENTER" ] ; then
    echo "`date` datadog.sh Failed to get datacenter code:$? datacenter:$DATACENTER" >> /tmp/upena_datadog.log
    exit 1
fi

INSTANCE_ID=`ec2-metadata -i | awk '{ print $2 }'`
if [ -z "$INSTANCE_ID" ] ; then
    echo "`date` Failed to get instance id" >> /tmp/upena_datadog.log
    exit 1
fi

ENV_NAME=`ec2-metadata | grep keyname | awk -F: '{ print $2 }'`
if [ -z "$ENV_NAME" ] ; then
    echo "`date` datadog.sh Failed to get env home" >> /tmp/upena_datadog.log
    exit 1
fi

UPENA_ID=`ec2-describe-tags -F resource-id=$INSTANCE_ID -F key=Name --region $DATACENTER | awk '{ print $5 }'`
if [ -z "$UPENA_ID" ] ; then
    echo "`date` datadog.sh Failed to get upena id" >> /tmp/upena_datadog.log
    exit 1
fi
UPENA="$UPENA_ID.jiveprivate.com"

echo "`date` Datadog status" >> /tmp/upena_datadog.log
sudo service datadog-agent status >> /tmp/upena_datadog.log

if [ ! -f /etc/init.d/datadog-agent ]; then
    echo "`date` Installing datadog agent" >> /tmp/upena_datadog.log
    DD_API_KEY=32b5100a0c14720cc68df0161a7bae86 bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"

    echo "`date` Stopping datadog agent" >> /tmp/upena_datadog.log
    sudo service datadog-agent stop >> /tmp/upena_datadog.log

    if [ -f /etc/dd-agent/datadog.conf ]; then
        echo "`date` Chmoding /etc/dd-agent/datadog.conf" >> /tmp/upena_datadog.log
        sudo chmod 666 /etc/dd-agent/datadog.conf
    fi

    if [ -f /etc/dd-agent/conf.d/http_check.yaml ]; then
        echo "`date` Removing existing /etc/dd-agent/conf.d/http_check.yaml" >> /tmp/upena_datadog.log
        sudo mv /etc/dd-agent/conf.d/http_check.yaml /etc/dd-agent/conf.d/http_check.yaml.1
    fi

    echo "`date` Generating datadog agent config " >> /tmp/upena_datadog.log
    cat << EOF > /etc/dd-agent/datadog.conf
[Main]
dd_url: https://app.datadoghq.com
api_key: 32b5100a0c14720cc68df0161a7bae86
gce_updated_hostname: yes
hostname: ${UPENA}
tags: aws, ${ENV_NAME}
EOF

    echo "`date` Restarting datadog agent" >> /tmp/upena_datadog.log
    sudo service datadog-agent restart >> /tmp/upena_datadog.log
fi

if [ ! -f /etc/dd-agent/conf.d/http_check.yaml ]; then
    echo "`date` Generating datadog agent http health checks" >> /tmp/upena_datadog.log
    sudo touch /etc/dd-agent/conf.d/http_check.yaml
fi

if ! grep -q "min_collection_interval: 60" /etc/dd-agent/conf.d/http_check.yaml; then
    echo "`date` Add min_collection_interval to datadog http health checks" >> /tmp/upena_datadog.log
    sudo cp -v /etc/dd-agent/conf.d/http_check.yaml /etc/dd-agent/conf.d/http_check.yaml.1

    sudo /bin/bash -c 'cat > /etc/dd-agent/conf.d/http_check.yaml' << EOF
init_config:

instances:
    -   name: ${ENV_NAME} Upena Health 50
        url: http://localhost:1174/health/check/${ENV_NAME}/0.5
        timeout: 1
        min_collection_interval: 60
    -   name: ${ENV_NAME} Upena Health 10
        url: http://localhost:1174/health/check/${ENV_NAME}/0.1
        timeout: 1
        min_collection_interval: 60
EOF

    echo "`date` Restarting datadog agent" >> /tmp/upena_datadog.log
    sudo service datadog-agent restart >> /tmp/upena_datadog.log
fi
