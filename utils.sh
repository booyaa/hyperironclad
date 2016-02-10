#!/bin/bash

######################################
# utility script, don't use directly #
######################################

findcontainer() {
  docker ps -qa --filter=name=$@
}

log() {
  #logger -s tagname $@
  echo $@
}
