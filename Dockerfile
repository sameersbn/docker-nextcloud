FROM sameersbn/php5-fpm:latest
MAINTAINER sameer@damagehead.com

ENV NEXTCLOUD_VERSION=9.0.55 \
    NEXTCLOUD_USER=${PHP_FPM_USER} \
    NEXTCLOUD_INSTALL_DIR=/var/www/nextcloud \
    NEXTCLOUD_DATA_DIR=/var/lib/nextcloud \
    NEXTCLOUD_CACHE_DIR=/etc/docker-nextcloud

ENV NEXTCLOUD_BUILD_DIR=${NEXTCLOUD_CACHE_DIR}/build \
    NEXTCLOUD_RUNTIME_DIR=${NEXTCLOUD_CACHE_DIR}/runtime

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8B3981E7A6852F782CC4951600A6F0A3C300EE8C \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      php5-pgsql php5-mysql php5-gd \
      php5-curl php5-intl php5-mcrypt php5-ldap \
      php5-gmp php5-apcu php5-imagick \
      mysql-client postgresql-client nginx gettext-base \
 && php5enmod mcrypt \
 && rm -rf /var/lib/apt/lists/*

COPY assets/build/ ${NEXTCLOUD_BUILD_DIR}/
RUN bash ${NEXTCLOUD_BUILD_DIR}/install.sh

COPY assets/runtime/ ${NEXTCLOUD_RUNTIME_DIR}/
COPY assets/tools/ /usr/bin/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp

VOLUME ["${NEXTCLOUD_DATA_DIR}"]

WORKDIR ${NEXTCLOUD_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:nextcloud"]
