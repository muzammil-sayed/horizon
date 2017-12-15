#
# Code taken from https://github.com/awslabs/aws-lambda-ddns-function
# But modified to only create/delete A records
# And only for a given domain ("data.jivehosted.com")
#
# pylint: disable=E111,E113,E114
#
import json
import boto3
import re
import uuid
import time
import random
from datetime import datetime

TABLE_NAME = 'Datateam-DDNS-Hostnames'

print('Loading function ' + datetime.now().time().isoformat())
sts_client = boto3.client('sts')
account_id = sts_client.get_caller_identity()["Account"]
print("Account ID: %s" % account_id)
if account_id == '999547976641':
    route53 = boto3.client('route53')
else:
    print('Account is not owner of data.jivehosted.com domain; assuming role...')
    assumed_role_obj = sts_client.assume_role(
        RoleArn="arn:aws:iam::999547976641:role/update-route53-data-jivehosted-com",
        RoleSessionName="AssumeRoleSession1"
    )
    credentials = assumed_role_obj['Credentials']
    route53 = boto3.client('route53',
        aws_access_key_id     = credentials['AccessKeyId'],
        aws_secret_access_key = credentials['SecretAccessKey'],
        aws_session_token     = credentials['SessionToken']
    )

ec2 = boto3.resource('ec2')
compute = boto3.client('ec2')
dynamodb_client = boto3.client('dynamodb')
dynamodb_resource = boto3.resource('dynamodb')


def lambda_handler(event, context):
    tables = dynamodb_client.list_tables()
    if TABLE_NAME in tables['TableNames']:
        print 'DynamoDB table already exists'
    else:
        create_table(TABLE_NAME)

    # Set variables
    # Get the state from the Event stream
    state = event['detail']['state']

    # Get the instance id, region, and tag collection
    instance_id = event['detail']['instance-id']
    region = event['region']
    table = dynamodb_resource.Table(TABLE_NAME)

    if state == 'running':
      time.sleep(60)
      instance = compute.describe_instances(InstanceIds=[instance_id])
      # Remove response metadata from the response
      instance.pop('ResponseMetadata')
      # Remove null values from the response. You cannot save a
      # dict/JSON document in DynamoDB if it contains null values
      # instance = remove_empty_from_dict(instance)
      # instance_dump = json.dumps(instance,default=json_serial)
      # instance_attributes = json.loads(instance_dump)
      az = instance['Reservations'][0]['Instances'][0]['Placement']['AvailabilityZone']  # noqa
      m = re.search('([a-z])$', az)
      az_suffix = m.group(1)
      private_dns_name = instance['Reservations'][0]['Instances'][0]['PrivateDnsName']  # noqa
      private_ip_addr  = instance['Reservations'][0]['Instances'][0]['PrivateIpAddress']  # noqa

    try:
      tags = instance['Reservations'][0]['Instances'][0]['Tags']
    except:
      tags = []

    hostname_prefix = ''
    make_dns = False
    make_dns_value = ''
    for tag in tags:
      if tag.get('Key', {}).lstrip().upper() == 'MAKE_DNS':
        make_dns = True
        make_dns_value = tag.get('Value')
      if tag.get('Key', {}).lstrip().upper() == 'NAME':
        hostname_prefix = tag.get('Value')

    if not make_dns and state == 'running':
      print("No Make_DNS tag found and state is 'running'. Exiting...")
      exit()

    cname_domain_suffix = 'data.jivehosted.com'
    cname_domain_suffix_id = get_zone_id(cname_domain_suffix)

    if make_dns and not re.search('^true$', make_dns_value, flags=re.IGNORECASE):
      m = re.search('^(?:(.*)[/.])?(.*)$', make_dns_value)
      if m.group(1):
        hostname_prefix = m.group(1)
      else:
        hostname_prefix = 'node'
      cname_domain_suffix = m.group(2) + '.' + cname_domain_suffix

    if state == 'running':
      for i in range(99):
        if i == 0:
          continue
        i = "%02d" % i
        cname_host_name = hostname_prefix + i + az_suffix
        cname = cname_host_name + '.' + cname_domain_suffix
        print "Trying %s" % cname
        try:
          table.put_item(
              Item={
                  'Hostname': cname,
                  'InstanceId': instance_id
              },
              ConditionExpression='attribute_not_exists(Hostname)'
          )
          print("Success! Creating r53 RR")
          try:
            create_resource_record(cname_domain_suffix_id,
                                   cname_host_name,
                                   cname_domain_suffix,
                                   'A', private_ip_addr)
          except BaseException as e:
            print e

          break
        except BaseException as e:
          print("Hostname %s is already taken" % cname)
    else:
      results = table.scan()
      for item in results['Items']:
        if item['InstanceId'] == instance_id:
          print("Found cname %s for instance %s" %
                (item['Hostname'], instance_id))
          cname = item['Hostname']
          cname_host_name = cname.split('.')[0]

          table.delete_item(Key={'Hostname': item['Hostname']})

          # delete A record in private zone
          try:
            delete_resource_record(cname_domain_suffix_id,
                                   cname,
                                   cname_domain_suffix,
                                   'A')
          except BaseException as e:
            print e


def create_table(table_name):
    dynamodb_client.create_table(
        TableName=table_name,
        AttributeDefinitions=[
            {
                'AttributeName': 'Hostname',
                'AttributeType': 'S'
            },
        ],
        KeySchema=[
            {
                'AttributeName': 'Hostname',
                'KeyType': 'HASH'
            },
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 4,
            'WriteCapacityUnits': 4
        }
    )
    table = dynamodb_resource.Table(table_name)
    table.wait_until_exists()


def create_resource_record(zone_id, host_name, hosted_zone_name, type, value):
    """This function creates resource records in the hosted zone
       passed by the calling function."""
    print('Updating %s record %s in zone %s ' %
          (type, host_name, hosted_zone_name))
    if host_name[-1] != '.':
        host_name = host_name + '.'
    route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Comment": "Updated by Lambda DDNS",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": host_name + hosted_zone_name,
                        "Type": type,
                        "TTL": 60,
                        "ResourceRecords": [
                            {
                                "Value": value
                            },
                        ]
                    }
                }
            ]
        }
    )


def delete_resource_record(zone_id, host_name, hosted_zone_name, type):
    """This function deletes resource records from the hosted
       zone passed by the calling function."""
    print('Deleting %s record %s in zone %s' %
          (type, host_name, hosted_zone_name))
#    if host_name[-1] != '.':
#        host_name = host_name + '.'

    rrs = route53.list_resource_record_sets(HostedZoneId=zone_id,
                                            StartRecordName=host_name,
                                            StartRecordType='A')

    ttl = rrs['ResourceRecordSets'][0]['TTL']
    value = rrs['ResourceRecordSets'][0]['ResourceRecords'][0]['Value']

    route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Comment": "Updated by Lambda DDNS",
            "Changes": [
                {
                    "Action": "DELETE",
                    "ResourceRecordSet": {
                        "Name": host_name,
                        "Type": type,
                        "TTL": ttl,
                        "ResourceRecords": [
                            {
                                "Value": value
                            },
                        ]
                    }
                },
            ]
        }
    )


def get_zone_id(zone_name):
    """This function returns the zone id for the zone name
       that's passed into the function."""
    if zone_name[-1] != '.':
        zone_name = zone_name + '.'
    hosted_zones = route53.list_hosted_zones()
    x = filter(lambda record: record['Name'] == zone_name,
               hosted_zones['HostedZones'])
    try:
        zone_id_long = x[0]['Id']
        zone_id = str.split(str(zone_id_long), '/')[2]
        return zone_id
    except:
        return None


def is_valid_hostname(hostname):
    """This function checks to see whether the hostname entered
       into the zone and cname tags is a valid hostname."""
    if hostname is None or len(hostname) > 255:
        return False
    if hostname[-1] == ".":
        hostname = hostname[:-1]
    allowed = re.compile("(?!-)[A-Z\d-]{1,63}(?<!-)$", re.IGNORECASE)
    return all(allowed.match(x) for x in hostname.split("."))


def get_dhcp_configurations(dhcp_options_id):
    """This function returns the names of the zones/domains that
       are in the option set."""
    zone_names = []
    dhcp_options = ec2.DhcpOptions(dhcp_options_id)
    dhcp_configurations = dhcp_options.dhcp_configurations
    for configuration in dhcp_configurations:
        zone_names.append(map(lambda x: x['Value'] + '.',
                              configuration['Values']))
    return zone_names


def reverse_list(list):
    """Reverses the order of the instance's IP address and helps
       construct the reverse lookup zone name."""
    if (re.search('\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}', list)) or (re.search('\d{1,3}.\d{1,3}.\d{1,3}\.', list)) or (re.search('\d{1,3}.\d{1,3}\.', list)) or (re.search('\d{1,3}\.', list)):  # noqa
        list = str.split(str(list), '.')
        list = filter(None, list)
        list.reverse()
        reversed_list = ''
        for item in list:
          reversed_list = reversed_list + item + '.'
        return reversed_list
    else:
      print 'Not a valid ip'
      exit()


def get_reversed_domain_prefix(subnet_mask, private_ip):
    """Uses the mask to get the zone prefix for the reverse lookup zone"""
    if 32 >= subnet_mask >= 24:
        third_octet = re.search('\d{1,3}.\d{1,3}.\d{1,3}.', private_ip)
        return third_octet.group(0)
    elif 24 > subnet_mask >= 16:
        second_octet = re.search('\d{1,3}.\d{1,3}.', private_ip)
        return second_octet.group(0)
    else:
        first_octet = re.search('\d{1,3}.', private_ip)
        return first_octet.group(0)


def create_reverse_lookup_zone(instance, reversed_domain_prefix, region):
    """Creates the reverse lookup zone."""
    print('Creating reverse lookup zone %s' %
          reversed_domain_prefix + 'in.addr.arpa.')
    route53.create_hosted_zone(
        Name=reversed_domain_prefix + 'in-addr.arpa.',
        VPC={
            'VPCRegion': region,
            'VPCId': instance['Reservations'][0]['Instances'][0]['VpcId']
        },
        CallerReference=str(uuid.uuid1()),
        HostedZoneConfig={
            'Comment': 'Updated by Lambda DDNS',
        },
    )


def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""
    if isinstance(obj, datetime):
        serial = obj.isoformat()
        return serial
    raise TypeError("Type not serializable")


def remove_empty_from_dict(d):
    """Removes empty keys from dictionary"""
    if type(d) is dict:
        return dict((k, remove_empty_from_dict(v)) for k, v in d.iteritems() if
                    v and remove_empty_from_dict(v))
    elif type(d) is list:
        return [remove_empty_from_dict(v) for v in d if
                v and remove_empty_from_dict(v)]
    else:
        return d


def associate_zone(hosted_zone_id, region, vpc_id):
    """Associates private hosted zone with VPC"""
    route53.associate_vpc_with_hosted_zone(
        HostedZoneId=hosted_zone_id,
        VPC={
            'VPCRegion': region,
            'VPCId': vpc_id
        },
        Comment='Updated by Lambda DDNS'
    )


def is_dns_hostnames_enabled(vpc):
    dns_hostnames_enabled = vpc.describe_attribute(
        DryRun=False,
        Attribute='enableDnsHostnames'
    )
    return dns_hostnames_enabled['EnableDnsHostnames']['Value']


def is_dns_support_enabled(vpc):
    dns_support_enabled = vpc.describe_attribute(
        DryRun=False,
        Attribute='enableDnsSupport'
    )
    return dns_support_enabled['EnableDnsSupport']['Value']


def get_hosted_zone_properties(zone_id):
    hosted_zone_properties = route53.get_hosted_zone(Id=zone_id)
    hosted_zone_properties.pop('ResponseMetadata')
    return hosted_zone_properties
