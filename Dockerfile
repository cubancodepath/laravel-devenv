# image from dockerhub
FROM php:8.1-fpm-alpine3.16

#install necessary packages
RUN apk update
RUN apk add curl git zip unzip libzip-dev libpng-dev $PHPIZE_DEPS imagemagick-dev libtool imagemagick freetype-dev libjpeg-turbo-dev libwebp-dev libxpm-dev libpq-dev sqlite-dev

#downloads the latest version of the imagick library for php 8.1
RUN pecl install imagick && docker-php-ext-enable imagick
#php extension
#configure gd library, pgsql, imagick, sqlite, and webp and install all php extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql --with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_mysql zip exif pdo_sqlite pdo pdo_pgsql pgsql gd


# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# configure user and group
RUN addgroup -g 1000 www
RUN adduser -u 1000 -G www -h /home/www -D www
# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=www:www . /var/www/html

# Change current user to www
USER www

EXPOSE 9000