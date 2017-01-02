FROM jebovic/alpine-nginx:latest

MAINTAINER Jérémy Baumgarth

# Install php
RUN apk update && \
    apk upgrade && \
    apk add --update libressl libressl-dev libssl1.0 supervisor redis \
    php7 \
    php7-fpm \
    php7-pdo_mysql \
    php7-ctype \
    php7-pdo \
    php7-zlib \
    php7-phar \
    php7-openssl \
    #php7-cli \
    php7-common \
    php7-dev \
    php7-opcache \
    php7-mbstring \
    php7-gd \
    php7-intl \
    php7-memcached \
    #php7-mysql \
    php7-redis \
    php7-curl \
    php7-json \
    php7-xsl \
    php7-xml \
    php7-mongodb \
    #php7-imagick \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    mkdir /var/log/supervisor && \
    rm -rf /var/cache/apk/*

# Nginx configuration
RUN rm /etc/nginx/conf.d/*
COPY config/nginx/conf.d/ /etc/nginx/conf.d/

# PHP configuration
RUN rm /etc/php7/php-fpm.d/www.conf
COPY config/php/php-fpm.d/ /etc/php7/php-fpm.d/
COPY config/php/conf.d/ /etc/php7/conf.d/

# Redis configuration
COPY config/redis/redis.conf /etc/redis.conf

# Default pages
COPY src/ /var/www/

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# init scrip
COPY init_script.sh /init_script.sh
RUN chmod +x /init_script.sh

CMD ["/bin/sh", "/init_script.sh"]
