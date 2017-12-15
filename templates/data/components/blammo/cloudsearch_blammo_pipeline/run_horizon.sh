#!/bin/bash
#

environment=$1
if [ -z "$environment" ]
then
  echo "[ERROR] Please specify an environment (integ|test|brewprod|prod)"
  exit 1
fi

declare -i index_num
seen_components_dir=0
rest_of_path=""
path_to_horizon=""
horizon_found=0
index_num=0
full_path=`pwd`
IFS='/' read -ra dir <<< "$full_path"
for part in ${dir[*]}
do
  index_num=${index_num}+1
  if [ ${horizon_found} == 0 ]
  then
    path_to_horizon="${path_to_horizon}/${part}"
    if [ "${part}" == "horizon" ]
    then
      horizon_found=1
      path_to_horizon="${path_to_horizon}/bin/horizon"
    fi
  fi
  if [ "${seen_components_dir}" == 1 ]
  then
    if [ -z "${rest_of_path}" ]
    then
      rest_of_path=${part}
    else
      rest_of_path=${rest_of_path}/${part}
    fi
  fi
  if [ "$part" == "components" ]
  then
    seen_components_dir=1
    account_name=${dir[${index_num}-1]}
  fi
done

if [ -z "${account_name}" ]
then
  echo "[ERROR] I can't figure out the account from your cwd"
  exit 1
fi

if [ -z "${rest_of_path}" ]
then
  echo "[ERROR] I can't figure out the components dir from your cwd"
  exit 1
fi

if [ ! -f "${path_to_horizon}" ]
then
  echo "[ERROR] I can't find horizon!"
  exit 1
fi

SCRIPT_NAME=`basename $0`
IFS='-' read -ra PAIR <<< "$SCRIPT_NAME"
ignore_me=${PAIR[0]}
action=${PAIR[1]}

if [ "$SCRIPT_NAME" == "run_horizon.sh" ]
then
  echo "[ERROR] Don't call run_horizon.sh directly."
  echo "        Instead, execute one of its symlinks: tf-plan, tf-apply, or tf-destroy"
  exit 1
fi
if [ "$action" != "plan" -a "$action" != "apply" -a "$action" != "destroy" ]
then
  echo "[ERROR] You're doing it wrong."
  exit 1
fi

if [ "$environment" == "test" -o "$environment" == "release" -o "$environment" == "integ" ]
then
  ughidunno="pipeline"
else
  ughidunno="$environment"
fi


echo "${path_to_horizon} -A ${action} -a ${account_name} -e $environment -n infra-${ughidunno} -p ${rest_of_path} -r administrator --regions us-west-2 -v"
echo -n "Execute [y/N]? "
read resp
if [ "$resp" != "y" -a "$resp" != "Y" -a "$resp" != "yes" ]
then
  echo "Taking no action."
  exit
else
  ${path_to_horizon} -A ${action} -a ${account_name} -e $environment -n infra-${ughidunno} -p ${rest_of_path} -r administrator --regions us-west-2 -v
fi
