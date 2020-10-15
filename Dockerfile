FROM php:7.4-fpm-alpine

#### timezone ####
ENV TZ JST-9;

#### apk update ####
RUN apk update

#### composer ####
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#### postgresql ####
RUN set -ex \
  && apk --no-cache add \
    postgresql-dev
RUN docker-php-ext-install pdo pdo_pgsql

#### redis ####
RUN apk add --no-cache --virtual .redis build-base autoconf
RUN pecl install -o -f redis \
    && docker-php-ext-enable redis
RUN apk del .redis
RUN rm -rf /tmp/pear

#### npm ####
RUN apk add npm alpine-sdk

#### docker ####
RUN apk add docker

#### php.ini ####
RUN { \
    echo 'date.timezone = Asia/Tokyo'; \
    echo 'expose_php = Off'; \
  } > /usr/local/etc/php/conf.d/00-base.ini

#### git ####
RUN apk add git

#### xdebug ####
RUN set -ex \
    && apk add --no-cache --virtual xdebug-builddeps \
        autoconf \
        gcc \
        libc-dev \
        make \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del --purge xdebug-builddeps

#### aws cli ####
RUN apk add --no-cache py-pip
RUN pip install awscli

#### jq ####
RUN apk add jq
