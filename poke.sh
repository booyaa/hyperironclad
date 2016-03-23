#!/bin/bash
# set -xv
source ./utils.sh

VERSION=1.0.0
usage() {
  SCRIPT=$(basename $0)
  echo Usage $SCRIPT $VERISION:
  echo 
  echo $SCRIPT app_name              - to enter data container
}

if [ -z $1 ];
then
  usage
  exit 1
fi

APP_NAME=$1

VOL_NAME=$APP_NAME
DATA_CONTAINER=$(findcontainers $VOL_NAME)
if [ -z $DATA_CONTAINER ];
then
  echo Error! Failed to find container: $APP_NAME!
  exit 1
fi

echo "Create temp busybox container with access to $APP_NAME...exit will destroy it (but not the data)"
docker run -it --rm --name temp_$APP_NAME --volumes-from $APP_NAME --link $APP_NAME busybox 

exit 0



