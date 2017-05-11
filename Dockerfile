FROM php:7.1.0-apache

ARG PIWIK_VERSION
ENV PIWIK_VERSION=${PIWIK_VERSION}

RUN apt-get update -qq
RUN apt-get dist-upgrade -y
RUN apt-get install -y --fix-missing \
    less \
    unzip \
    curl \
    ca-certificates \
    vim \
    libapache2-mod-geoip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Get piwik
RUN cd /tmp && \
      curl -O curl -O http://builds.piwik.org/piwik-$PIWIK_VERSION.zip
RUN cd /tmp && \
      unzip piwik-$PIWIK_VERSION.zip
RUN cd /tmp/piwik/misc \
      && curl -fsSL -o GeoIPCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
      && gunzip GeoIPCity.dat.gz
RUN cd /tmp && \
      cp -r piwik/* /var/www/html/

# Apache ELB and security custom conf
COPY docker_resources/000-default.conf /etc/apache2/sites-available/
COPY docker_resources/apache_security.conf /etc/apache2/conf-available/
# Enable apache rewrite to https and headers
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2disconf security
RUN a2enconf apache_security

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
