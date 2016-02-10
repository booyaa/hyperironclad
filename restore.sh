#!/usr/bin/env bash

source ./utils.sh

VOLNAME=$1
SQLFILE=$2
TARBALL=$3

if [ -z $VOLNAME ];
then
  log Must specify data container name $VOLNAME
  exit 1
fi

if [ -z $SQLFILE ];
then
  log Must specify sql backup to restore
  exit 1
fi

if [ -z $TARBALL ];
then
  log Must specify tar ball to restore from
  exit 1
fi

CONTAINER=$(findcontainer $VOLNAME)

if [ -z $CONTAINER ];
then
  log Failed to find data container: $VOLNAME
  exit 1
fi

# TODO mysql restore

if [ ! -f $TARBALL ];
then
  log Couldn\'t find $TARBALL
  exit 1
fi

# TODO fail if not .tar.gz
file $TARBALL

docker run -it --rm --name temp_wordpress_file_restore \
  --volumes-from $VOLNAME \
  -v $(pwd):/backup \
  ubuntu:14.04 tar xvfz /backup/$TARBALL -C /var/www/html

echo Restore successfully completed!
exit 0 
