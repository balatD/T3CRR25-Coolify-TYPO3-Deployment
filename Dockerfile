FROM php:8.3-apache as base

RUN apt-get update && \
    apt-get install -y libicu-dev

RUN apt-get install -y libzip-dev zip && \
    docker-php-ext-install zip && \
    docker-php-ext-install intl && \
    docker-php-ext-install mysqli

RUN docker-php-ext-install opcache

WORKDIR /var/www/html

FROM base as config

COPY config/ config
COPY packages/ packages
# COPY var/ var
COPY public/ public
# Exclude fileadmin directory from copy
RUN rm -rf /var/www/html/public/fileadmin
COPY composer.json composer.json
COPY composer.lock composer.lock

FROM config as composer

RUN apt-get update && apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev

COPY deployment/config/httpd/production.conf /etc/apache2/sites-available/production.conf
COPY deployment/config/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

FROM composer as access_rights

RUN a2enmod rewrite &&  \
    a2dissite 000-default && \
    a2ensite production && \
    service apache2 restart

# Create directory for persistent storage
RUN mkdir -p /var/www/html/public/fileadmin

RUN chown -R www-data:www-data /var/www/html

FROM access_rights as typo3_commands

EXPOSE 8080
