#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Use: $0 [type] [num_instances] [num_volumes]"
    echo "e.g. $0 api 3 3"
    exit 0
fi

TYPE=$1
OUT=upena_${TYPE}/upena_${TYPE}.tf
N_INSTANCE=$2
N_VOLUME=$3

echo > $OUT

#----------------------------------------------------------------------------------------
# variables
#----------------------------------------------------------------------------------------

cat upena_gen_variables.tf | sed "s/__TYPE__/$TYPE/g" >> $OUT

#----------------------------------------------------------------------------------------
# enable
#----------------------------------------------------------------------------------------

cat <<EOF >> $OUT
variable "upena_${TYPE}_enabled" {
    description = ""
    default = {
EOF

for (( i=1; i<=$N_INSTANCE; i++ )); do
    echo "i${i} = \"0\"" >> $OUT
    echo "i${i}_bootstrap = \"./bootstrap_provision.sh\"" >> $OUT
    echo "i${i}_az = \"\"" >> $OUT
    echo "i${i}_subnet_key = \"\"" >> $OUT
    for (( v=1; v<=$N_VOLUME; v++ )); do
        echo "i${i}_v${v} = \"0\"" >> $OUT
    done
done

cat <<EOF >> $OUT
    }
}
EOF

#----------------------------------------------------------------------------------------
# Instances
#----------------------------------------------------------------------------------------

DEVICES=(_ e f g h i j k l m n o p)
for (( i=1; i<=$N_INSTANCE; i++ )); do
    subnet=$[$i - 1]

    echo >> $OUT
    cat upena_gen_instance.tf | sed "s/__TYPE__/$TYPE/g" | sed "s/__INSTANCE__/$i/g" | sed "s/__SUBNET__/$i/g" >> $OUT

    for (( v=1; v<=$N_VOLUME; v++ )); do
        echo >> $OUT
        cat upena_gen_volume.tf | sed "s/__TYPE__/$TYPE/g" | sed "s/__INSTANCE__/$i/g" | sed "s/__VOLUME__/$v/g" | sed "s/__DEVICE__/${DEVICES[$v]}/g" >> $OUT
    done
done
