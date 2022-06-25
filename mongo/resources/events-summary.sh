#!/bin/bash

source $CSAP_FOLDER/bin/csap-environment.sh

mongoHost=${EVENTS_HOST-$(hostname):${csapPrimaryPort}}

print_separator "mongoHost: $mongoHost"

source $csapResourceFolder/common/mongo-helpers.sh

print_command \
  'CSAP Event count using filter: {$gte:"2021-01-01",$lt:"2022-01-01"}' \
  "$(mongo_run_command 'event' 'db.eventRecords.count({"createdOn.date":{$gte:"2021-01-01",$lt:"2022-01-01"}})')"



today=$(date +%Y-%m-%d)
yesterday=$(date --date="1 day ago" +%Y-%m-%d)

command='db.eventRecords.count({"createdOn.date":{$gte:"'$yesterday'",$lt:"'$today'"}})'
print_command \
  "CSAP Event count yesterday: '$yesterday'" \
  "$(mongo_run_command 'event' $command)"
 
 
 
print_command \
  "mongo server status (20 lines)" \
  "$(mongo_run_command 'event' "printjson(db.serverStatus())" | head -20)"
	

#scriptFolder=$csapResourceFolder/common ;
scriptToRun=$csapResourceFolder/common/eventSamples.js;

print_command \
  "Running script $scriptToRun in event db" \
  "$(mongo_run_script $scriptToRun event)"
  
exit

# print event records on day
mongo_run_command 'event' 'printjson( db.eventRecords.find({"createdOn.date":{$gte:"2019-01-22",$lt:"2019-01-23"}}).toArray() )'

# sample dump
mongo_run -q "{\"createdOn.date\":{\$gt:\"$targetFrom\"}}" 


















