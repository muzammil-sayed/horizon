#!/bin/bash

# Set environment variables
declare -r AWS_ACCESS_KEY_ID=$(curl -s ${AWS_METADATA_ENDPOINT} | jq .AccessKeyId | sed 's/"//g')
declare -r AWS_SECRET_ACCESS_KEY=$(curl -s ${AWS_METADATA_ENDPOINT} | jq .SecretAccessKey | sed 's/"//g')
declare -r AWS_SESSION_TOKEN=$(curl -s ${AWS_METADATA_ENDPOINT} | jq .Token | sed 's/"//g')

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN}"
export AWS_DEFAULT_REGION="us-west-2"

# Terraform
if [[ ${VERSION} ]]; then
  wget https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip -P /tmp/
  unzip /tmp/terraform_${VERSION}_linux_amd64.zip -d /tmp/
else
  echo "Terrform VERSION needs to be specified for this container."
  exit 1
fi

# Run Horizon
if [[ ${ACTION} ]] && [[ ${ALIAS} ]]; then
  python /horizon/bin/horizon -B /tmp/terraform -A ${ACTION} -l ${ALIAS}
else
  echo "Terraform ACTION and Horizon ALIAS need to be specified for this container."
  exit 1
fi


# Premerge tasks - Horizon is unable to delete certain resources because of
# dependency cycles. The following AWS api calls will clean up after a Horizon
# destroy task is run.
if [[ ${ACTION} == destroy ]] && [[ ${ALIAS} == premerge_test_usw ]]; then
  declare -r retry_count=10
  # Delete leftover ENI
  count=0
  while (( count <= ${retry_count} )); do
    declare -a eni=($(aws ec2 describe-network-interfaces --filters Name=group-name,Values=*premerge* | jq '.[][].NetworkInterfaceId' | sed 's/"//g'))
    # Wait a little while for ENIs to be detached
    if [[ ${#eni[@]} -eq 1 ]]; then
      aws ec2 delete-network-interface --network-interface-id ${eni}
    elif [[ ${#eni[@]} -gt 1 ]]; then
      ((count++))
      sleep 10
      echo "Retry #${count}: Waiting 10 seconds for ENIs to detach."
    else
      break
    fi
  done

  # Delete leftover SGs
  count=0
  while (( count <= ${retry_count} )); do
    declare -a security_groups=($(aws ec2 describe-security-groups --filters Name=group-name,Values=*premerge* | jq '.[][].GroupId' | sed 's/"//g'))
    for group in ${security_groups[@]}
    do
      declare rules=$(aws ec2 describe-security-groups --filters Name=group-id,Values=${group} --query 'SecurityGroups[0].[IpPermissions]' | jq -c '.[][1]')
      declare -r revoke_rules=$(aws ec2 revoke-security-group-ingress --group-id ${group} --ip-permissions [${rules}])
      ${revoke_rules}
      aws ec2 delete-security-group --group-id ${group}
    done
    if [[ ${#security_groups[@]} -ne 0 ]]; then
      ((count++))
      sleep 10
      echo "Retry #${count}: Waiting 10 seconds before trying to delete SGs again."
    else
      break
    fi
  done

  # Delete leftover volumes
  count=0
  while (( count <= ${retry_count} )); do
    declare -a volumes=($(aws ec2 describe-volumes  --filters Name=tag-key,Values="Name" Name=tag-value,Values="*premerge*" Name=status,Values=available | jq '.[][].VolumeId' | sed 's/"//g'))
    for volume in ${volumes[@]}
    do
      aws ec2 delete-volume --volume-id ${volume}
    done
    if [[ ${#volumes[@]} -ne 0 ]]; then
      ((count++))
      sleep 10
      echo "Retry #${count}: Waiting 10 seconds before trying to delete volumes again."
    else
      break
    fi
  done
fi
