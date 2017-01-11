#Dockerized Piwik

A fully working dockerized piwik installation built on top of a php:7.1.0-apache official docker image.

This builds a working piwik image which includes the GeoLiteCity database and adds some security settings for apache included in ```docker_resources```.

Docker has to have the following environment variables and a accessible database so that piwik can work.

They can be found in
```entrypoint.sh```

 and are
 ```
 "${DB_HOST}"
 "${DB_USER}"
 "${DB_PASSWORD}"
 "${DB_NAME}"
 "${DB_TABLES_PREFIX}"
 "${SITE_FQDN}"
 "${PROXY_CLIENT_HEADERS}"
 "${SALT}"
 ```
