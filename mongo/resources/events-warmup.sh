#!/bin/bash

source $CSAP_FOLDER/bin/csap-environment.sh

HOST=${EVENTS_HOST-$(hostname):${csapPrimaryPort}}

scriptFolder=$csapResourceFolder/common ;
scriptToRun=postRestartWarmup.js;

print_with_head "Mounting: '$scriptFolder' in image: '$MONGO_UTIL', running: '$scriptToRun'"

function mongo_run() {
  uid=$(id --user $USER) ; gid=$(id --group $USER) ; 
  docker run --user=$uid:$gid --rm $*
}

mongo_run -v $scriptFolder:/scripts $MONGO_UTIL \
  mongo event --host $HOST \
  -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
  /scripts/$scriptToRun















































