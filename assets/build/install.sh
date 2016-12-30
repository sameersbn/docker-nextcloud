#!/bin/bash
set -e

mkdir -p ${NEXTCLOUD_INSTALL_DIR}

if [[ ! -f ${NEXTCLOUD_BUILD_DIR}/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 ]]; then
  echo "Downloading Nextcloud ${NEXTCLOUD_VERSION}..."
  wget "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" -O ${NEXTCLOUD_BUILD_DIR}/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2
fi

echo "Extracting Nextcloud ${NEXTCLOUD_VERSION}..."
tar -xf ${NEXTCLOUD_BUILD_DIR}/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 --strip=1 -C ${NEXTCLOUD_INSTALL_DIR}
rm -rf ${NEXTCLOUD_BUILD_DIR}/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2

# required by nextcloud
sed -i "s|[;]*[ ]*always_populate_raw_post_data = .*|always_populate_raw_post_data = -1|" /etc/php5/fpm/php.ini
sed -i "s|[;]*[ ]*always_populate_raw_post_data = .*|always_populate_raw_post_data = -1|" /etc/php5/cli/php.ini

# remove default nginx virtualhost
rm -rf /etc/nginx/sites-enabled/default

# set directory permissions
find ${NEXTCLOUD_INSTALL_DIR}/ -type f -print0 | xargs -0 chmod 0640
find ${NEXTCLOUD_INSTALL_DIR}/ -type d -print0 | xargs -0 chmod 0750
chown -R root:${NEXTCLOUD_USER} ${NEXTCLOUD_INSTALL_DIR}/
chown -R ${NEXTCLOUD_USER}: ${NEXTCLOUD_INSTALL_DIR}/apps/
chown -R ${NEXTCLOUD_USER}: ${NEXTCLOUD_INSTALL_DIR}/config/
chown -R ${NEXTCLOUD_USER}: ${NEXTCLOUD_INSTALL_DIR}/themes/
chown root:${NEXTCLOUD_USER} ${NEXTCLOUD_INSTALL_DIR}/.htaccess
chmod 0644 ${NEXTCLOUD_INSTALL_DIR}/.htaccess
chown root:${NEXTCLOUD_USER} ${NEXTCLOUD_INSTALL_DIR}/.user.ini
chmod 0644 ${NEXTCLOUD_INSTALL_DIR}/.user.ini
