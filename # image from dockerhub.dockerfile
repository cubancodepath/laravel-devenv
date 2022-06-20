# image from dockerhub
FROM php:8.1-fpm-alpine3.16

#install necessary packages
RUN apk update
RUN apk add curl git zip unzip libzip-dev libpng-dev imagemagick-dev imagemagick freetype-dev libjpeg-turbo-dev libwebp-dev libxpm-dev libpq-dev sqlite-dev

#downloads the latest version of the imagick library for php 8.1
RUN mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1;

#php extension
#configure gd library, pgsql, imagick, sqlite, and webp and install all php extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \ 
    pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_mysql zip exif pdo_sqlite pdo pdo_pgsql pgsql imagick gd


# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install cron and schedule a laravel job
RUN echo "* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1" > /etc/cron.d/laravel-cron

# configure user and group
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/sh -g www www

# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=www:www . /var/www/html

# Change current user to www
USER www

EXPOSE 9000