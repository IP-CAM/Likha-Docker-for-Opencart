#!/bin/bash -e


echo "###########################################"
echo "### Likha Innovative Technologies, Inc. ###"
echo "###########################################"


OPENCART_INSTALL_DIR="/var/www/html/install"

if [ -d $OPENCART_INSTALL_DIR ]; then
    echo "== OpenCart Setup =="
    cd $OPENCART_INSTALL_DIR
    set -x
    php cli_install.php install \
        --db_hostname ${DATABASE_HOST} \
        --db_username ${DATABASE_USER} \
        --db_password ${DATABASE_PASS} \
        --db_database ${DATABASE_DB} \
        --db_driver mysqli \
        --db_port 3306 \
        --username ${OPENCART_USER} \
        --password ${OPENCART_PASS} \
        --email "${OPENCART_EMAIL}" --http_server ${OPENCART_URL}
    cd /
    rm -rf $OPENCART_INSTALL_DIR
    set +x
    echo "== OpenCart Setup Complete =="
fi



apache2-foreground