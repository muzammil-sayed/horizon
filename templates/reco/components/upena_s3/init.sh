#!/bin/bash

cd /upena

echo "`date` reset upena files..." >> /tmp/upena_init.log
rm -f upena.jar
rm -f nohup.out
rm -f upena.out
rm -f upena.err

echo "`date` download upena bin..." >> /tmp/upena_init.log
wget --output-document upena.jar 'http://nexus-int.eng.jiveland.com/service/local/artifact/maven/redirect?r=modified-thirdparty&g=com.jivesoftware.os.upena&a=upena-deployable&v=RELEASE&e=jar'
