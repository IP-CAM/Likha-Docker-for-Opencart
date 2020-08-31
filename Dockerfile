FROM php:7.3-apache
LABEL maintainer="edmond <edmond@likha.tech>"

COPY rootfs /
RUN chmod +x /likha-entrypoint.sh

RUN a2enmod rewrite headers

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip libzip-dev

RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev libwebp-dev unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-webp-dir=/usr \
    && docker-php-ext-install gd mysqli pdo_mysql zip

WORKDIR /var/www/html

ENV OPENCART_VER 3.0.3.6
ENV OPENCART_MD5 FF9034C333C2F818E0727918C1132F2A
ENV OPENCART_URL https://github.com/opencart/opencart/releases/download/${OPENCART_VER}/opencart-${OPENCART_VER}.zip
ENV OPENCART_FILE opencart.zip
ENV OPENCART_USER oc_admin
ENV OPENCART_PASS oc_password
ENV OPENCART_EMAIL 'shop@localhost'
ENV DATABASE_HOST localhost
ENV DATABASE_USER opencart
ENV DATABASE_PASS opencart
ENV DATABASE_DB opencart
ENV OPENCART_HTTPURL 'http://localhost' 

RUN set -xe \
    && curl -sSL ${OPENCART_URL} -o ${OPENCART_FILE} \
    && echo "${OPENCART_MD5}  ${OPENCART_FILE}" | md5sum -c \
    && unzip ${OPENCART_FILE} 'upload/*' -d /var/www/html/ \
    && mv /var/www/html/upload/* /var/www/html/ \
    && rm -r /var/www/html/upload/ \
    && mv config-dist.php config.php \
    && mv admin/config-dist.php admin/config.php \
    && rm ${OPENCART_FILE} \
    && chown -R www-data:www-data /var/www


ENTRYPOINT [ "/likha-entrypoint.sh" ]

# CMD [ "apache2-foreground" ]