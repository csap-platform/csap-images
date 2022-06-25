#!/bin/bash

source $CSAP_FOLDER/bin/csap-environment.sh

mongoBackupFolder=${mongoBackupFolder:-$nfs_mount/csap-events-migrate-latest}
mongoDestHost=${mongoDestHost:-$(hostname):${csapPrimaryPort}}


print_with_head "Verifying migration storage location: '$mongoBackupFolder'"

if [ ! -e $mongoBackupFolder ] ; then 
  print_with_head "Failed to find: $mongoBackupFolder"
  exit  ;
fi;



function mongo_run() {
  
  uid=$(id --user $USER) ; gid=$(id --group $USER) ;
  
  docker run --rm --user="$uid:$gid" \
    --volume="$mongoBackupFolder:/workdir/" \
    --workdir="/workdir/" \
    $MONGO_UTIL $*
}



function performRestores() {
  
  if [ $mongoSourceHost == $mongoDestHost ] ; then
    print_error "source and destination hosts are the same: $mongoSourceHost" ;
    exit 99 ;
  fi ;
  
  print_separator "restoring $mongoDestHost events"
  mongo_run mongorestore --host $mongoDestHost \
    -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
    --dir=/workdir/event-dump/
  
  
  
  print_separator "restoring $mongoDestHost metrics"
  mongo_run mongorestore --host $mongoDestHost \
    -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
    --dir=/workdir/metrics-dump/
  
  
  print_separator "restoring $mongoDestHost metricsAttributes"
  mongo_run mongorestore --host $mongoDestHost \
    -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
    --dir=/workdir/metrics-dump-attributes/
}  

performRestores


