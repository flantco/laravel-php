FROM php:7.1-apache

RUN apt-get update \
 && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libpq-dev \
    libjpeg-dev \
    libssl-dev \
    libmcrypt-dev \
    libpng12-dev \
    libz-dev \
    libmemcached-dev \
    python-software-properties \ 
    build-essential \
 && pecl install mongodb \
 && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/ext-mongo.ini \
 && docker-php-ext-install -j$(nproc) iconv mcrypt \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) gd \
 && docker-php-ext-install gd \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install pdo_pgsql \
 && docker-php-ext-install zip \
 && docker-php-ext-install bcmath \
 && docker-php-ext-install opcache \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/apache2.conf \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/default-ssl.conf
RUN { \
    echo 'date.timezone=UTC'; \
    echo 'display_errors=Off'; \
    echo 'log_errors=On'; \
    echo 'memory_limit = 1G'; \
    echo 'upload_max_filesize = 2048M'; \
    echo 'post_max_size = 2048M'; \
 } > /usr/local/etc/php/conf.d/laravel.ini

WORKDIR /var/www
