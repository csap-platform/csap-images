#!/bin/bash

source $CSAP_FOLDER/bin/csap-environment.sh

NOW=$(date +"%h-%d-%I-%M-%S")

dumpDays=${dumpDays:-1} ;
dumpFromDate=$(date --date="$dumpDays days ago" +%Y-%m-%d) ;

performRestore=${performRestore:-false} ;

mongoBackupFolder=${mongoBackupFolder:-$nfs_mount/csap-events-migrate-$NOW}
mongoSourceHost=${mongoSourceHost:-$(hostname)}
mongoDestHost=${mongoDestHost:-$(hostname):${csapPrimaryPort}}


print_with_head "Creating migration storage location: '$mongoBackupFolder'"
run_using_root mkdir --parents $mongoBackupFolder --verbose
run_using_root chown -R $USER $mongoBackupFolder



function mongo_run() {
  
  uid=$(id --user $USER) ; gid=$(id --group $USER) ;
  
  docker run --rm --user="$uid:$gid" \
    --volume="$mongoBackupFolder:/workdir/" \
    --workdir="/workdir/" \
    $MONGO_UTIL $*
}


# today=$(date +%Y-%m-%d)
# yesterday=$(date --date="1 day ago" +%Y-%m-%d)
# tenDays=$(date --date="10 days ago" +%Y-%m-%d)
# thirtyDays=$(date --date="30 days ago" +%Y-%m-%d)


query='{ "createdOn.date": { "$gt": "'$dumpFromDate'" } }'
append_file "$query" $mongoBackupFolder/query-by-date.json



# events are small - getting them all --queryFile=/workdir/query-by-date.json 

function performExports() {
  
  local eventsFilter="--queryFile=/workdir/query-by-date.json" ;
  local eventsMsg="since $dumpFromDate" ;
  if (( $dumpDays > 15 )) ; then
    eventsFilter="" ;
    eventsMsg="dumpDays > 15 - dumping entire collection" ;
  fi ;
  
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

performExports ;


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
  
if $performRestore ; then
  performRestores ;
else 
  print_with_head "performRestore set to false - exiting"
fi ;


print_with_head "Migration completed"
#run_using_root rm -rf $mongoBackupFolder

