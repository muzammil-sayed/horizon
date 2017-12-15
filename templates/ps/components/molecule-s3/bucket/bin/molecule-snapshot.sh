#!/bin/bash

EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document \
    | awk -F\" '/"region"/{print $4}')
EC2_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
BOOMI_MOLECULE_TYPE=$(aws ec2 describe-tags \
    --filters \
        Name=key,Values=service_component \
        Name=resource-type,Values=instance \
        Name=resource-id,Values=$EC2_INSTANCE_ID \
    --region $EC2_REGION \
    --query 'Tags[0].{tag:Value}' \
    --output text)
EC2_MOLECULE_VOLUME_ID=$(aws ec2 describe-volumes \
    --filters \
        Name=attachment.delete-on-termination,Values=false \
        Name=attachment.instance-id,Values=${EC2_INSTANCE_ID} \
        Name=availability-zone,Values=${EC2_AZ} \
    --region ${EC2_REGION} \
    --query "Volumes[0].{ID:VolumeId}" \
    --output text)

if [[ -n $EC2_MOLECULE_VOLUME_ID ]]; then
    # Create snapshot
    snapID=$(sed -r 's/"(.*)"/\1/' <(aws ec2 create-snapshot \
        --volume-id $EC2_MOLECULE_VOLUME_ID \
        --description "$(tr - \  <<<${BOOMI_MOLECULE_TYPE^}), $(date '+%d %B %Y %H:%M:%S %Z')" \
        --region ${EC2_REGION} \
        --query 'SnapshotId'))

    # Name snapshot and apply tags
    aws ec2 describe-tags \
        --filters \
            Name=key,Values=account_name,pipeline_phase,region,jive_service,service_component \
            Name=resource-type,Values=instance \
            Name=resource-id,Values=$EC2_INSTANCE_ID \
        --region $EC2_REGION \
        --query 'Tags[*].{key:Key,value:Value}' \
        --output text \
    | awk '
        {print "Key=" $1 ",Value=" $2}
        /service_component/{
            sub("-", " ", $2)
            print "Key=Name,Value=" toupper(substr($2, 1, 1)) substr($2, 2)
        }' \
    | xargs -d $'\n' aws ec2 create-tags \
        --resource $snapID \
        --region $EC2_REGION \
        --tags
fi

# Delete old snapshots
python - <<-EOD $EC2_REGION $EC2_INSTANCE_ID
	import sys
	import datetime
	import dateutil.parser
	from boto.ec2 import connect_to_region

	daysToKeepSnapshots = 30
	region = sys.argv[1]
	instanceID = sys.argv[2]

	instanceFilter = {'resource-type': 'instance', 'resource-id': instanceID}

	ec2 = connect_to_region(region)
	instanceTags = ec2.get_all_tags(filters=instanceFilter)

	snapshotTags = [t for t in instanceTags if t.name in ['pipeline_phase', 'jive_service', 'service_component']]
	snapshotFilters = {"tag:%s" % t.name: t.value for t in snapshotTags}

	snapshots = ec2.get_all_snapshots(filters=snapshotFilters)

	for snapshot in snapshots:
	    snapshotDate = dateutil.parser.parse(snapshot.start_time).replace(tzinfo=None)
	    if datetime.datetime.today() - snapshotDate > datetime.timedelta(daysToKeepSnapshots):
	        print "Deleting snapshot: {}".format(snapshot.description)
	        snapshot.delete()
EOD
