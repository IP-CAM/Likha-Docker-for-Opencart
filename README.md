# OpenCart

OpenCart is an online store management system. It is PHP-based, using a MySQL database and HTML components.


# Prerequisites

## MySQL Database
An external database will be used for this OpenCart installation.

### (Sample) Manual Installation of the Database
```console
docker run \
 --net=host \
 --name mariadb \
 -e MYSQL_ROOT_PASSWORD=opencart \
 -e MYSQL_USER=opencart \
 -e MYSQL_PASSWORD=opencart \
 -e MYSQL_DATABASE=opencart \
 -d mariadb:latest
```

## Persistent Disk
A persistent disk is used to retain the OpenCart data along side with the MySQL. 


# Configuration

## Environment Variables

### User Site Configuration
 - `OPENCART_USER`: OpenCart Admin username. Default: **oc_admin**
 - `OPENCART_PASS`: OpenCart Admin password. Default: **oc_password**
 - `OPENCART_EMAIL`: OpenCart application email. Default: **shop@localhost**

### MySQL Database
 - `DATABASE_HOST`: MySQL endpoint.
 - `DATABASE_USER`: OpenCart Database User. Default: **opencart**
 - `DATABASE_PASS`: OpenCart Database Password. Default: **opencart**
 - `DATABASE_DB`: OpenCart Database. Default: **opencart**
 - `OPENCART_HTTPURL`: OpenCart URL. Default: **http://localhost**

# Deployment

```console
docker run \
 --net=host \
 --name opencart \
 -e DATABASE_HOST="192.168.100.157" \
 -e DATABASE_USER="opencart" \
 -e DATABASE_PASS="opencart" \
 -e DATABASE_DB="opencart" \
 -e OPENCART_USER="oc_admin" \
 -e OPENCART_PASS="oc_password" \
 -e OPENCART_EMAIL="shop@localhost" \
 -e OPENCART_URL="http://localhost/" \
 -v path/to/persistence:/likha \
 -d likha/likha-docker-opencart:latest
```