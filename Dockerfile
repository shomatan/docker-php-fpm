FROM php:7.1.5-fpm-alpine

MAINTAINER Shoma Nishitateno <shoma416@gmail.com>

RUN set -ex \
	&& addgroup -g 1000 -S www \
	&& adduser  -u 1000 -D -S -G www www

RUN set -ex \
    && sed -i "s/user =.*/user = www/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/group =.*/group = www/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.mode =.*/listen.mode = 0660/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s|listen =.*|listen = /var/run/php-fpm/php-fpm.sock|" /usr/local/etc/php-fpm.d/zz-docker.conf

COPY files/php.ini /usr/local/etc/php/conf.d/

CMD ["php-fpm", "-F"]