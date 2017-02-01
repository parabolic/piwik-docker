#!/usr/bin/env bash

APACHE_CONF_DIR="/etc/apache2/"
PIWIK_DIR="/var/www/html"

# Set up piwik
cd ${PIWIK_DIR}
./console config:set --section="database" --key="host" --value="${DB_HOST}"
./console config:set --section="database" --key="username" --value="${DB_USER}"
./console config:set --section="database" --key="password" --value="${DB_PASSWORD}"
./console config:set --section="database" --key="dbname" --value="${DB_NAME}"
./console config:set --section="database" --key="tables_prefix" --value="${DB_TABLES_PREFIX}"
./console config:set --section="General" --key="trusted_hosts[]" --value="${SITE_FQDN}"
./console config:set --section="General" --key="proxy_client_headers[]" --value="${PROXY_CLIENT_HEADERS}"
./console config:set --section="General" --key="salt" --value="${SALT}"

# Takes care of the db upgrade when chaging version
./console core:update

chown -R www-data:www-data ${PIWIK_DIR}

# Start apache in the foreground
source ${APACHE_CONF_DIR}/envvars
# Tail is for the logs to go to stdout.
apachectl -d ${APACHE_CONF_DIR} -f apache2.conf -e info -DFOREGROUND & tail -f /var/log/apache2/*
