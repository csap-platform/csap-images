FROM sensus/centos:7

ENV IMAGE_MOUNT /var/images
ENV CONFIG_MOUNT /var/config
ENV SRC_REGISTRY ${SRC_REGISTRY:-docker://docker.lab.sensus.net}
ENV DEST_FILENAME ${DEST_FILENAME:-platform_images.tar.gz}

VOLUME ${IMAGE_MOUNT}
VOLUME ${CONFIG_MOUNT}

# install skopeo
RUN yum install -y skopeo

COPY create-registry-seeder.sh /root/create-registry-seeder.sh
# need to change file mod for windows build support
RUN chmod 755 /root/create-registry-seeder.sh

# At container run time copy docker-image-list out of this registry into
# the deploy registry.
ENTRYPOINT /root/create-registry-seeder.sh ${SRC_REGISTRY} ${DEST_FILENAME}
