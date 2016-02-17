#!/bin/bash
# set -xv
source ./utils.sh

VERSION=1.0.0
usage() {
  SCRIPT=$(basename $0)
  echo Usage $SCRIPT $VERISION:
  echo 
  echo $SCRIPT app_name              - to enter data container
  echo 
  echo $SCRIPT app_name suffix       - to override the default data container 
  echo                                 naming convention -wp-data
  echo 
  echo $SCRIPT app_name suffix image - in addition to above, also override
  echo                                 override the image to use for the
  echo                                 temporary cotainer 
}

if [ -z $1 ];
then
  usage
  exit 1
fi

APP_NAME=$1
if [ -z $2 ];
then
  SUFFIX=-mysql
else
  echo override
  SUFFIX=-$2
fi  

if [ -z $3 ];
then
  IMAGE=mariadb:5.5
else
  IMAGE=$3
fi

set -xv
VOL_NAME=$APP_NAME$SUFFIX
DATA_CONTAINER=$(findrunningcontainers $VOL_NAME)
set +xv
if [ -z $DATA_CONTAINER ];
then
  echo Error! Failed to find mysql container for $APP_NAME!
  exit 1
fi

echo "Create temp container...exit will destroy it (but not the data)"
docker run -it --rm --name temp_for_$APP_NAME --link $VOL_NAME:mysql \
	$IMAGE sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

exit 0



