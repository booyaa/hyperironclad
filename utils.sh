#!/bin/bash

######################################
# utility script, don't use directly #
######################################

# docker
# TODO: create funcs that return only one cid
# TODO: how do we reference arrays in bash?
findcontainers() {
  docker ps -qa --filter="name=$@"
}


findrunningcontainers() {
  docker ps -qa --filter="name=$@" --filter="status=running"
}

# misc
isfiletype() {
  # returns 1 if found otherwise 0

  FILE=$1
  shift
  TERM=$@
  # echo $FILE $TERM
  # e.g. gzip compressed data, from Unix, last modified: Wed Feb 10 08:17:48 2016
  FILE_OUTPUT=$(file --print0 --no-pad --brief $FILE | cut -f1 -d',') 
  echo $FILE_OUTPUT | grep --quiet "$TERM" 
  if [ $? -eq 0 ];
  then echo 1
  else echo 0
  fi
}

# infra
log() {
  #logger -s tagname $@
  echo $@
}
