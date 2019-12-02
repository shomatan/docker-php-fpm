#
# https://github.com/prime-strategy/kusanagi-php7
#
FROM php:7.3.5-fpm-alpine3.9

LABEL maintainer "Shoma Nishitateno <shoma416@gmail.com>"

# Environment variable
ARG APCU_VERSION=5.1.17
ARG APCU_BC_VERSION=1.0.5
ARG MOZJPEG_VERSION=3.3.1

RUN set -ex \
    && apk update \
    && apk upgrade \
	&& addgroup -g 1000 -S www \
	&& adduser  -u 1000 -D -S -G www www

RUN set -ex \
    && apk update \
    && apk add --update --no-cache --virtual .build-php \
		$PHPIZE_DEPS \
		build-base \
		automake \
		gettext \
		libtool \
		nasm \
		mariadb \
		mariadb-dev \
		postgresql \
		postgresql-dev \
		gd-dev \
		libpng-dev \
		libwebp-dev \
		libxpm-dev \
		zlib-dev \
		libzip-dev \
		freetype-dev \
		bzip2-dev \
		libexif-dev \
		xmlrpc-c-dev \
		pcre-dev \
		gettext-dev \
		libxslt-dev \
		pcre-dev \
		openldap-dev \
		imap-dev \
		icu-dev \
		curl \
		imagemagick \
		imagemagick-dev \
		libsodium \
		libsodium-dev \
		gettext \
    && cd /tmp \
    # mozjpeg
	&& curl -LO https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz#//mozjpeg-${MOZJPEG_VERSION}.tar.gz \
	&& tar xf mozjpeg-${MOZJPEG_VERSION}.tar.gz \
	&& cd mozjpeg-${MOZJPEG_VERSION} \
	&& autoreconf -fiv \
	&& mkdir build && cd build \
	&& sh ../configure --with-jpeg8 --prefix=/usr \
	&& make -j$(getconf _NPROCESSORS_ONLN) install \
    # PHP7.3
	&& pecl channel-update pecl.php.net \
	&& docker-php-ext-configure gd --with-jpeg-dir=/usr/include \
		--with-xpm-dir=/usr/include --with-webp-dir=/usr/include \
		--with-png-dir=/usr/include --with-freetype-dir=/usr/include/ \
	&& docker-php-ext-install \
		mysqli \
		pgsql \
		opcache \
		gd \
		calendar \
		imap \
		ldap \
		bz2 \
		zip \
		pdo \
		pdo_mysql \
		pdo_pgsql \
		bcmath \
		exif \
		gettext \
		pcntl \
		soap \
		sockets \
		sysvsem \
		sysvshm \
		xmlrpc \
		xsl \
	&& pecl install imagick \
	&& pecl install libsodium \
	&& pecl install apcu-$APCU_VERSION \
	&& pecl install apcu_bc-$APCU_BC_VERSION \
	&& docker-php-ext-enable imagick apcu apc \
	&& mv /usr/bin/envsubst /tmp/ \
    && runPath="/usr/local/bin/php /usr/local/lib/php/extensions/no-debug-non-zts-20180731/*.so /tmp/envsubst /usr/bin/mogrify /usr/bin/wrjpgcom /usr/bin/rdjpgcom /usr/bin/cjpeg /usr/bin/jpegtran /usr/bin/djpeg /usr/bin/tjbench /usr/lib/libturbojpeg.so.0.1.0 /usr/lib/libjpeg.so.8.1.2" \
    && runDeps="$( \
	    scanelf --needed --nobanner --format '%n#p' $runPath \
	    | tr ',' '\n' \
	    | sort -u \
	    | grep -v jpeg \
	    | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
    && strip $runPath \
    && apk add --no-cache --virtual .php7-rundeps $runDeps \
    && apk del .build-php \
    && mv /tmp/envsubst /usr/bin/envsubst \
	&& cd / \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apc.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
	&& rm -f /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
	&& rm -rf /tmp/mozjpeg* /tmp/pear /usr/include /usr/lib/pkgconfig /usr/lib/*a /usr/share/doc /usr/share/man \
	&& apk add pngquant optipng jpegoptim ssmtp \
	&& mkdir -p /etc/php7.d/conf.d /etc/php7-fpm.d \
	&& cp /usr/local/etc/php/conf.d/* /etc/php7.d/conf.d/ \
	&& cp /usr/local/etc/php-fpm.d/* /etc/php7-fpm.d/ \
	&& mkdir -p /var/log/php7-fpm \
	&& ln -sf /dev/stdout /var/log/php7-fpm/www-error.log \
	&& ln -sf /dev/stderr /var/log/php7-fpm/www-slow.log

RUN	set -xe \
    && mkdir -p /var/lib/php7/session /var/lib/php7/wsdlcache  \
	&& chown www:www /var/lib/php7/session /var/lib/php7/wsdlcache \
	&& echo mysqli.default_socket=/var/run/mysqld/mysqld.sock >> /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini \
	&& echo pdo_mysql.default_socket = /var/run/mysqld/mysqld.sock >> /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini \
	&& cd /tmp \
	&& curl -LO https://composer.github.io/installer.sha384sum \
	&& curl -LO https://getcomposer.org/installer \
	&& sha3sum installer.sha384sum \
	&& php installer --filename=composer --install-dir=/usr/local/bin \
	&& rm installer 

COPY files/*.ini /usr/local/etc/php/conf.d/
COPY files/opcache*.blacklist /usr/local/etc/php.d/
COPY files/www.conf /usr/local/etc/php-fpm.d/www.conf.template
COPY files/php7-fpm.conf /usr/local/etc/php-fpm.conf
COPY files/php.ini-production /usr/local/etc/php.conf
COPY files/docker-entrypoint.sh /usr/local/bin

RUN set -xe \
	&& chown -R www:www /usr/local/etc \
	&& chown -R www:www /var/www/html \
	&& chmod 755 /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

USER www

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/usr/local/sbin/php-fpm", "--nodaemonize", "--fpm-config", "/usr/local/etc/php-fpm.conf", "--allow-to-run-as-root"]