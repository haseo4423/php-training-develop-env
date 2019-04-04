FROM php:5.6-apache

RUN apt-get update \
  && apt-get install -y \
  curl \
  build-essential \
  openssl libssl-dev \
  ca-certificates \
  libcurl4-openssl-dev \
  libmcrypt-dev \
  libpq-dev \
  libxml2-dev \
  libldap2-dev \
  libgd-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  zlib1g-dev \
  zip \
  unzip \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) mcrypt curl iconv tokenizer mbstring pdo pdo_pgsql xmlrpc \
  && a2enmod rewrite \
  && a2enmod ssl \
  && a2dissite 000-default

# PEAR server が down しているため、直接インストール
RUN curl -LO https://github.com/pear/Log/releases/download/1.13.1/Log-1.13.1.tgz \
  && pear install Log-1.13.1.tgz

# Install Xdebug
RUN pecl install xdebug-2.5.5 && \
  docker-php-ext-enable xdebug && \
  sed -i '1 a xdebug.idekey="ps_sample_php5"' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_autostart=true' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_mode=req' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_handler=dbgp' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_connect_back=1 ' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_port=9002' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_enable=1' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install timecop
RUN pecl install timecop-beta && \
  docker-php-ext-enable timecop

# Install ldap
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
  docker-php-ext-install ldap

RUN mkdir -p /var/log/php

RUN usermod -u 1000 www-data && \
  groupmod -g 1000 www-data

# CA 追加
COPY ./openssl/ca/sample-dev.cacrt.pem /root/openssl/ca/sample-dev.cacrt.pem
COPY ./openssl/ca/sample-dev.canokey.pem /root/openssl/ca/sample-dev.canokey.pem

RUN cp /root/openssl/ca/sample-dev.cacrt.pem /usr/share/ca-certificates/sample-dev.cacrt.pem
RUN echo "sample-dev.cacrt.pem" >> /etc/ca-certificates.conf
RUN /usr/sbin/update-ca-certificates

# SSL証明書 作成
COPY ./cmd/create_ssl.sh /root/cmd/create_ssl.sh
RUN chmod 744 /root/cmd/create_ssl.sh
RUN /bin/bash -c "source /root/cmd/create_ssl.sh"

COPY ./apache2/extra_mod/mod_setenvifplus.so /usr/local/apache2/modules/mod_setenvifplus.so
RUN chmod 755 /usr/local/apache2/modules/mod_setenvifplus.so
