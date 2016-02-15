#!/usr/bin/env bash

source ./utils.sh

VOLNAME=$1
TARBALL=$2
SQLNAME=$3
SQLFILE=$4
SQLDB=$5

if [ -z $VOLNAME ];
then
  log Must specify data container name
  exit 1
fi

if [ -z $TARBALL ];
then
  log Must specify tar ball to restore from
  exit 1
fi

if [ -z $SQLNAME ];
then 
  log Must specify mysql server name
  exit 1
fi

if [ -z $SQLFILE ];
then
  log Must specify sql backup to restore
  exit 1
fi

if [ -z $SQLDB ];
then
  log Must specify sql database name
  exit 1
fi

log Pre-flight check for file restore...

CONTAINER=$(findcontainers $VOLNAME)
if [ -z $CONTAINER ];
then
  log Failed to find data container: $VOLNAME
  exit 1
fi

log Performing file restore... 

if [ ! -f $TARBALL ];
then
  log Couldn\'t find $TARBALL
  exit 1
fi

# TODO fail if not .tar.gz
# file -0  --brief dontcommitmebro/wordpress.tgz | cut -f1 -d','
# file -0  --brief dontcommitmebro/wordpress.tar.gz | cut -f1 -d','
# gzip compressed data
#
# file -0  --brief dontcommitmebro/wordpress.tar | cut -f1 -d','
# POSIX tar archive

if [ $(isfiletype $TARBALL gzip) -eq 0 ];
# if [[ $(isfiletype $TARBALL gzip) -eq 0 \
#    && $(isfiletype $TARBALL tar) -eq 0]];
then
  log didn\'t find wordpress plain or compress tarball\!
  exit 1
fi

docker run -it --rm --name temp_wordpress_file_restore \
  --volumes-from $VOLNAME \
  -v $(pwd):/backup \
  ubuntu:14.04 tar xvfz /backup/$TARBALL -C /var/www/html

log Pre-flight check for mysql restore

CONTAINER=$(findrunningcontainers $SQLNAME)
if [ -z $CONTAINER ];
then
  log Failed to find mysql server container: $SQLNAME
  exit 1
fi

if [ ! -f $SQLFILE ];
then
  log Couldn\'t find $SQLFILE
  exit 1
fi

log Performing mysql restore
# test if database exists
# TODO drop and create database first
docker run -it --rm --name temp_mysql_restore \
  --link $SQLNAME:mysql --volume $(pwd)/$SQLFILE:/backup/wordpress.sql \
  mariadb:5.5 sh -c 'exec mysql -h "$MYSQL_PORT_3306_TCP_ADDR" -p"$MYSQL_PORT_3306_TCP_PORT" -u root -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" '$SQLDB'< /backup/wordpress.sql'


log Restore successfully completed!
exit 0 
