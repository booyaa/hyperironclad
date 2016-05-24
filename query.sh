#!/bin/bash
# set -xv
source ./utils.sh

VERSION=2.0.0
usage() {
  SCRIPT=$(basename $0)
  echo Usage $SCRIPT $VERISION:
  echo 
  echo $SCRIPT server_name           - to enter container
}

if [ -z $1 ];
then
  usage
  exit 1
fi

SQL_NAME=$1

CONTAINERID=$(findrunningcontainers $SQL_NAME)
if [ -z $CONTAINERID ];
then
  echo Error! Failed to find mysql container for $SQL_NAME!
  exit 1
fi
docker exec -it $SQL_NAME sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'

exit 0



