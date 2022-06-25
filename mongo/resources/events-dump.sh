#!/bin/bash

source $CSAP_FOLDER/bin/csap-environment.sh




mongoBackupFolder=${mongoBackupFolder:-$nfs_mount/csap-events-migrate-latest}
mongoSourceHost=${mongoSourceHost:-$(hostname)}


print_with_head "Creating migration storage location: '$mongoBackupFolder'"
run_using_root mkdir --parents $mongoBackupFolder --verbose
run_using_root chown -R $USER $mongoBackupFolder

dumpDays=${dumpDays:-1} ;
dumpFromDate=$(date --date="$dumpDays days ago" +%Y-%m-%d) ;

query='{ "createdOn.date": { "$gt": "'$dumpFromDate'" } }'
append_file "$query" $mongoBackupFolder/query-by-date.json



function mongo_run() {
  
  uid=$(id --user $USER) ; gid=$(id --group $USER) ;
  
  docker run --rm --user="$uid:$gid" \
    --volume="$mongoBackupFolder:/workdir/" \
    --workdir="/workdir/" \
    $MONGO_UTIL $*
}

function performExports() {
  
  local eventsFilter="--queryFile=/workdir/query-by-date.json" ;
  local eventsMsg="since $dumpFromDate" ;
  if (( $dumpDays > 15 )) ; then
    eventsFilter="" ;
    eventsMsg="dumpDays > 15 - dumping entire collection" ;
  fi
  print_separator "dumping $mongoSourceHost events: $eventsMsg"
  mongo_run mongodump \
    --host=$mongoSourceHost --username=$MONGO_INITDB_ROOT_USERNAME --password=$MONGO_INITDB_ROOT_PASSWORD \
    --authenticationDatabase=admin \
    --db=event --collection=eventRecords $eventsFilter \
    --out=/workdir/event-dump/
  
  
  print_separator "dumping $mongoSourceHost metrics: since $dumpFromDate"
  mongo_run mongodump \
    --host=$mongoSourceHost --username=$MONGO_INITDB_ROOT_USERNAME --password=$MONGO_INITDB_ROOT_PASSWORD \
    --authenticationDatabase=admin \
    --db=metricsDb  --collection=metrics --queryFile=/workdir/query-by-date.json \
    --out /workdir/metrics-dump/
  
  
  print_separator "dumping $mongoSourceHost metricsAttributes: since $dumpFromDate"
  mongo_run mongodump \
    --host=$mongoSourceHost --username=$MONGO_INITDB_ROOT_USERNAME --password=$MONGO_INITDB_ROOT_PASSWORD \
    --authenticationDatabase=admin \
    --db=metricsDb  --collection=metricsAttributes --queryFile=/workdir/query-by-date.json \
    --out /workdir/metrics-dump-attributes/
}

performExports

