#!/bin/bash



mongoHost=${EVENTS_HOST-$(hostname):${csapPrimaryPort}}

print_separator "mongoHost: $mongoHost"

function mongo_run() {
  
  
  local mongoDb="$1" ;
	shift 1 ;
	local mongoCommand="$*" ;
  
  print_line "mongoDb: '$mongoDb', mongoCommand: '$mongoCommand',  image: '$MONGO_UTIL'"
  
  uid=$(id --user $USER) ; gid=$(id --group $USER) ; 
  docker run --user=$uid:$gid --rm $MONGO_UTIL \
    mongo $mongoDb --host $mongoHost \
    -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
    $mongoCommand
}

function mongo_run_command() {
  
  
  local mongoDb="$1" ;
	shift 1 ;
	local mongoCommand="$*" ;
	
  mongo_run $mongoDb --eval $mongoCommand
}


function mongo_run_script() {
  
  local scriptToRun=${1:-$csapResourceFolder/common/eventSamples.js}
  local dbName=${2:-event}
  
  print_line "Mounting: '$scriptToRun' in image: '$MONGO_UTIL'"
  
  docker run --rm -v $scriptToRun:/scriptToRun $MONGO_UTIL \
    mongo $dbName \
    --host $mongoHost -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
  	/scriptToRun
}

