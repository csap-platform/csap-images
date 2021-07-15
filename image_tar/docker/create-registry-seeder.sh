#! /bin/bash

set -x

_debug=${DEBUG_OPTION}

src_reg=$1
dest_dir=/var/images
dest_filename=$2

scratch_dir=${dest_dir}/scratch
image_name_list=/var/config/docker-image-list

mkdir -p ${scratch_dir}
cp ${image_name_list} ${scratch_dir}
while read image_name
do
    mkdir -p ${scratch_dir}/${image_name}
    skopeo ${_debug} --insecure-policy copy \
        --src-tls-verify=0 \
        --dest-tls-verify=0 \
        ${src_reg}/${image_name} \
        dir:${scratch_dir}/${image_name}
done < ${image_name_list}

tar -zcvf ${dest_dir}/${dest_filename} -C ${scratch_dir} .
# change mod to allow host system to clean up file.
chmod 666 ${dest_dir}/${dest_filename}

rm -rf ${scratch_dir}

echo "CREATED IMAGE TAR"

