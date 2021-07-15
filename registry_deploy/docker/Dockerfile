FROM sensus/centos:7

ENV DOCKER_IMAGE_FILE ${DOCKER_IMAGE_FILE:-platform_images_0.1.tgz}
ENV DEPLOY_REGISTRY ${DEPLOY_REGISTRY:-docker://172.17.0.1:5000}
ENV IMAGE_DIR /var/images
ENV WORK_DIR /var/work

VOLUME WORK_DIR
VOLUME IMAGE_DIR

# install skopeo
RUN yum install -y skopeo

COPY deploy-registry-seeder.sh /root/deploy-registry-seeder.sh
# need to chmod for windows build support
RUN chmod 755 /root/deploy-registry-seeder.sh

# At container run time deploy the docker image file to the docker registry
ENTRYPOINT exec /root/deploy-registry-seeder.sh ${IMAGE_DIR} ${DOCKER_IMAGE_FILE} ${DEPLOY_REGISTRY} ${WORK_DIR}

