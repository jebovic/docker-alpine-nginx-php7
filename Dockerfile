FROM jebovic/alpine-nginx:latest

MAINTAINER Jérémy Baumgarth

# Install php
RUN apk update && \
    apk upgrade && \
    apk add --update php7 php7-fpm php7-cli php7-common php7-dev php7-opcache php7-mbstring php7-gd php7-intl php7-memcached php7-mysql php7-redis php7-curl php7-json php7-xsl php7-xml php7-mongodb php7-imagick && \
    rm -rf /var/cache/apk/*

# init scrip
COPY init_script.sh /init_script.sh
RUN chmod +x /init_script.sh

# symlink stout to access log file, an stderr to error log file
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/bin/sh", "/init_script.sh"]
