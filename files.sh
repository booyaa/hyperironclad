#!/usr/bin/env bash
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
  SUFFIX=-wp-data
else
  echo override
  SUFFIX=-$2
fi  

if [ -z $3 ];
then
  IMAGE=debian:jessie
else
  IMAGE=$3
fi

VOL_NAME=$APP_NAME-wp-data
DATA_CONTAINER=$(findcontainer $VOL_NAME)
if [ -z $DATA_CONTAINER ];
then
  echo Error! Failed to find data container for $APP_NAME!
  exit 1
fi

echo "Create temp container...exit will destroy it (but not the data)"
docker run -it --rm --name temp_for_$APP_NAME --volumes-from $VOL_NAME debian:jessie bash

exit 0



