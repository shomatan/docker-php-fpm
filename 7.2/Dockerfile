FROM php:7.2.10-fpm-alpine

LABEL maintainer "Shoma Nishitateno <shoma416@gmail.com>"

RUN set -ex \
	&& addgroup -g 1000 -S www \
	&& adduser  -u 1000 -D -S -G www www

RUN set -ex \
    && sed -i "s/user =.*/user = www/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/group =.*/group = www/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.owner =.*/listen.owner = www/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.group =.*/listen.group = www/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.mode =.*/listen.mode = 0660/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s|listen =.*|listen = /var/run/php-fpm/php-fpm.sock|" /usr/local/etc/php-fpm.d/zz-docker.conf

COPY files/php.ini /usr/local/etc/php/conf.d/

VOLUME /var/run/php-fpm

CMD ["php-fpm", "-F"]