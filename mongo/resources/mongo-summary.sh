#!/bin/bash

source $CSAP_FOLDER/bin/csap-environment.sh
source $csapResourceFolder/common/mongo-helpers.sh

print_command \
  "CSAP Metric count" \
  "$(mongo_run_command 'metricsDb' 'db.metrics.count()')"

print_command \
  "CSAP Event count" \
  "$(mongo_run_command 'event' 'db.eventRecords.count()')"


today=$(date +%Y-%m-%d)
yesterday=$(date --date="1 day ago" +%Y-%m-%d)

command='db.eventRecords.count({"createdOn.date":{$gte:"'$yesterday'",$lt:"'$today'"}})'
print_command \
  "CSAP Event count yesterday: '$yesterday'" \
  "$(mongo_run_command 'event' $command)"
  

command='db.metrics.count({"createdOn.date":{$gte:"'$yesterday'",$lt:"'$today'"}})'
print_command \
  "CSAP Metric count yesterday: '$yesterday'" \
  "$(mongo_run_command 'metricsDb' $command)"
  





