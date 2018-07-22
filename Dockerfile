FROM ubuntu:bionic-20180526

LABEL maintainer="sameer@damagehead.com"

ENV PHP_VERSION=7.2 \
    NEXTCLOUD_VERSION=13.0.4 \
    NEXTCLOUD_USER=www-data \
    NEXTCLOUD_INSTALL_DIR=/var/www/nextcloud \
    NEXTCLOUD_DATA_DIR=/var/lib/nextcloud \
    NEXTCLOUD_ASSETS_DIR=/etc/docker-nextcloud

ENV NEXTCLOUD_BUILD_ASSETS_DIR=${NEXTCLOUD_ASSETS_DIR}/build \
    NEXTCLOUD_RUNTIME_ASSETS_DIR=${NEXTCLOUD_ASSETS_DIR}/runtime

COPY assets/build/ ${NEXTCLOUD_BUILD_ASSETS_DIR}/

RUN chmod 755 ${NEXTCLOUD_BUILD_ASSETS_DIR}/install.sh

RUN ${NEXTCLOUD_BUILD_ASSETS_DIR}/install.sh

COPY assets/runtime/ ${NEXTCLOUD_RUNTIME_ASSETS_DIR}/

COPY assets/tools/ /usr/bin/

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

WORKDIR ${NEXTCLOUD_INSTALL_DIR}

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["app:nextcloud"]

EXPOSE 80/tcp 9000/tcp
