#!/bin/bash

######################################
# utility script, don't use directly #
######################################

# TODO: create funcs that return only one cid
# TODO: how do we reference arrays in bash?
findcontainers() {
  docker ps -qa --filter="name=$@"
}


findrunningcontainers() {
  docker ps -qa --filter="name=$@" --filter="status=running"
}


log() {
  #logger -s tagname $@
  echo $@
}
