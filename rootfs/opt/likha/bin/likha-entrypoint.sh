#!/bin/bash

LIKHA_DATA_DIR="/likha"
OPENCART_DATA_DIR="/likha/opencart"
OPENCART_STORAGE_CACHE_DIR="/tmp/opencart/system/storage/cache"
OPENCART_IMAGE_CACHE_DIR="/tmp/opencart/image/cache"

LIKHA_MEDIA_DIR="/opt/likha/media"

echo "###########################################"
echo "### Likha Innovative Technologies, Inc. ###"
echo "###########################################"

if [ ! -d $OPENCART_DATA_DIR ]; then
    mkdir -p $OPENCART_DATA_DIR
fi 

if [ ! -L /var/www ]; then
    rm -rf /var/www
    ln -s $OPENCART_DATA_DIR /var/www
fi 

mkdir -p $OPENCART_STORAGE_CACHE_DIR
touch $OPENCART_STORAGE_CACHE_DIR/index.php
chown -R www-data: $OPENCART_STORAGE_CACHE_DIR

mkdir -p $OPENCART_IMAGE_CACHE_DIR
touch $OPENCART_IMAGE_CACHE_DIR/index.php
chown -R www-data: $OPENCART_IMAGE_CACHE_DIR
 
if [ ! -f "$LIKHA_DATA_DIR/.initialized" ]; then

    unzip $LIKHA_MEDIA_DIR/$OPENCART_FILE 'upload/*.*' -d /var/www/
    mv /var/www/upload/ /var/www/html/

    pushd /var/www/html
    rm -rf .idea
    mv config-dist.php config.php
    mv admin/config-dist.php admin/config.php
    popd

    OPENCART_INSTALL_DIR="/var/www/html/install"
    if [ -d $OPENCART_INSTALL_DIR ]; then
        pushd $OPENCART_INSTALL_DIR

        echo "== OpenCart Setup  Start =="
        php cli_install.php install \
            --db_hostname ${DATABASE_HOST} \
            --db_username ${DATABASE_USER} \
            --db_password ${DATABASE_PASS} \
            --db_database ${DATABASE_DB} \
            --db_driver mysqli \
            --db_port 3306 \
            --username ${OPENCART_USER} \
            --password ${OPENCART_PASS} \
            --email "${OPENCART_EMAIL}" \
            --http_server "http://${OPENCART_HOST}/"
        rm -rf $OPENCART_INSTALL_DIR

        # Update HTTPS URLs
        sed -i '/HTTPS_SERVER/ s/http:\/\//https:\/\//g' /var/www/html/config.php
        sed -i '/HTTPS_SERVER/ s/http:\/\//https:\/\//g' /var/www/html/admin/config.php
        sed -i '/HTTPS_CATALOG/ s/http:\/\//https:\/\//g' /var/www/html/admin/config.php

        # Move the cache to tmp
        rm -rf /var/www/html/system/storage/cache
        ln -s $OPENCART_STORAGE_CACHE_DIR /var/www/html/system/storage/cache
        chown www-data: /var/www/html/system/storage/cache

        rm -rf /var/www/html/image/cache
        ln -s $OPENCART_IMAGE_CACHE_DIR /var/www/html/image/cache
        chown www-data: /var/www/html/image/cache
        echo "== OpenCart Setup Complete =="

        popd 
    fi

    chown -R www-data: /var/www
    chown -R www-data: $OPENCART_DATA_DIR
    touch $LIKHA_DATA_DIR/.initialized
fi

if [ -f $LIKHA_MEDIA_DIR/$OPENCART_FILE ]; then 
    rm $LIKHA_MEDIA_DIR/$OPENCART_FILE
fi


apache2-foreground