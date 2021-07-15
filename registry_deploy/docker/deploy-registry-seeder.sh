! /bin/bash

set -x

_debug=${DEBUG_OPTION}

image_dir=$1
src_file=$2
dest_reg=$3
work_dir=$4
scratch_dir=${work_dir}/scratch

# untar tarbal
mkdir -p ${scratch_dir}
tar -xvzf ${image_dir}/${src_file} --directory ${scratch_dir}

image_name_list=${scratch_dir}/docker-image-list

while read image_name
do
    skopeo ${_debug} --insecure-policy copy \
        --src-tls-verify=0 \
        --dest-tls-verify=0 \
        dir:${scratch_dir}/${image_name} \
        ${dest_reg}/${image_name}
done < ${image_name_list}


rm -rf ${scratch_dir}
