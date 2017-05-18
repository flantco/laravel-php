FROM php:7.0-apache

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update \
 && apt-get install -y \
    git \
    libfreetype6-dev \
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
    wkhtmltopdf \
    xvfb \
 && docker-php-ext-install -j$(nproc) iconv mcrypt \
 && docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib --with-freetype-dir=/usr/include/freetype2 \
 && docker-php-ext-install gd \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install pdo_pgsql \
 && docker-php-ext-install zip \
 && docker-php-ext-install -j$(nproc) gd \
 && docker-php-ext-install bcmath \
 #&& docker-php-ext-install opcache \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/apache2.conf \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/default-ssl.conf \
 && curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer
RUN { \
    echo 'date.timezone=UTC'; \
    echo 'display_errors=Off'; \
    echo 'log_errors=On'; \
    echo 'memory_limit = 128M'; \
    echo 'upload_max_filesize = 20M'; \
    echo 'post_max_size = 20M'; \
 } > /usr/local/etc/php/conf.d/laravel.ini
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host = dockerhost" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN apt-get update
RUN apt-get -y install nodejs
RUN /usr/bin/npm install -g gulp

WORKDIR /var/www
