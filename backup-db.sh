#!/bin/bash

source ./utils.sh
set -eo pipefail

VERSION=1.0.0
usage() {
  SCRIPT=$(basename $0)
  echo >&2 "Usage $SCRIPT $VERSION:"
  echo >&2
  echo >&2 "$SCRIPT mysql_container dumpfile.sql [root_password[ [db_name] [db_user] [db_host] [db_network]"
  echo >&2 "If MYSQL_ROOT_PASSWORD is defined it will be used"
}

if [ $# -lt 2 ];
then
  usage
  exit 1
fi

SQL_SERVER_NAME=$1
SQL_FILE=$2

# defaults
DB_NAME=${4:-wordpress}
DB_USER=${5:-root}
DB_HOST=${6:-mysql}
DB_NETW=${7:-wordpress}
DB_PASS=${3:-$MYSQL_ROOT_PASSWORD}

# really missing --link
if [ -z $DB_PASS ];
then
  echo >&2 "No root password!"
  exit 2
fi

if [ ! -f $SQL_FILE ];
then
  # otherwise docker will create $SQL_FILE as a directory
  echo >&2 "Creating stub for $SQL_FILE"
  touch $SQL_FILE
fi

CONTAINER=$(findrunningcontainers $SQL_SERVER_NAME)
if [ -z "$CONTAINER" ];
then
  log Failed to find sql server container: $SQL_SERVER_NAME
  exit 4
fi


docker run --name temp_sql --net $DB_NETW --rm -it \
  -e DB_USER=${DB_USER} \
  -e DB_NAME=${DB_NAME} \
  -e DB_HOST=${DB_HOST} \
  -e DB_PASS=${DB_PASS} \
  -v $PWD/$SQL_FILE:/backup/backup.sql \
  mariadb:5.5 \
  sh -c 'mysqldump -u"$DB_USER" -h"$DB_HOST" -p"$DB_PASS" "$DB_NAME" > /backup/backup.sql'

echo >&2 "Backup $DB_NAME on $DB_HOST to $SQL_FILE"
exit 0
