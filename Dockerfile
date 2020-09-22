FROM php:7.3-apache
LABEL maintainer="edmond <edmond@likha.tech>"

VOLUME ["/likha"]

COPY rootfs /
RUN chmod +x -R /opt/likha/bin \
    && mkdir -p /opt/likha/media \
    && mkdir -p /likha

RUN a2enmod rewrite headers

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip libzip-dev

RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev libwebp-dev unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-webp-dir=/usr \
    && docker-php-ext-install gd mysqli pdo_mysql zip

WORKDIR /opt/likha/media

ENV OPENCART_VER 3.0.3.5
ENV OPENCART_MD5 60A8D889F1BDC764AD85F1736CAC421C
ENV OPENCART_URL https://github.com/opencart/opencart/releases/download/${OPENCART_VER}/opencart-${OPENCART_VER}.zip
ENV OPENCART_FILE opencart.zip
ENV OPENCART_HOST 'localhost' 
ENV OPENCART_USER 'oc_admin'
ENV OPENCART_PASS 'oc_password'
ENV OPENCART_EMAIL 'shop@localhost'
ENV DATABASE_HOST 'localhost'
ENV DATABASE_USER 'opencart'
ENV DATABASE_PASS 'opencart'
ENV DATABASE_DB 'opencart'

RUN set -xe \
    && curl -sSL ${OPENCART_URL} -o ${OPENCART_FILE} \
    && echo "${OPENCART_MD5}  ${OPENCART_FILE}" | md5sum -c \
    && rm -rf /var/www

WORKDIR /

ENTRYPOINT [ "/opt/likha/bin/likha-entrypoint.sh" ]
