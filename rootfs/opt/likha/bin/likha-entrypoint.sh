#!/bin/bash

LIKHA_DATA_DIR="/likha"
OPENCART_DATA_DIR="/likha/opencart"
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
    mkdir -p /var/www/html
fi 
 
if [ ! -f "$LIKHA_DATA_DIR/.initialized" ]; then
    pushd /var/www/html

    unzip $LIKHA_MEDIA_DIR/$OPENCART_FILE 'upload/*' -d /var/www/html
    mv /var/www/html/upload/* /var/www/html/
    rm -rf /var/www/html/upload/
    mv config-dist.php config.php
    mv admin/config-dist.php admin/config.php
    chown -R www-data: /var/www
    chown -R www-data: $OPENCART_DATA_DIR

    OPENCART_INSTALL_DIR="/var/www/html/install"
    if [ -d $OPENCART_INSTALL_DIR ]; then
        echo "== OpenCart Setup =="
        cd $OPENCART_INSTALL_DIR
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
        echo "== OpenCart Setup Complete =="
    fi
    touch $LIKHA_DATA_DIR/.initialized
    popd
fi

if [ -f $LIKHA_MEDIA_DIR/$OPENCART_FILE ]; then 
    rm $LIKHA_MEDIA_DIR/$OPENCART_FILE
fi

cd /
apache2-foreground