# imagen de dockerhub que descargara
FROM php:8.0-fpm


RUN apt-get update
RUN apt-get install -y git zip unzip libzip-dev libpng-dev

# algunas configuraciones para que funcione el contenedor

RUN docker-php-ext-install pdo pdo_mysql zip gd

RUN apt-get install -y libmagickwand-dev --no-install-recommends 

RUN pecl install imagick && docker-php-ext-enable imagick    

# instala composer en el contenedor
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# da permisos para editar los archivos en esta ruta del container
# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=www:www . /var/www/html

# Change current user to www
USER www

EXPOSE 9000