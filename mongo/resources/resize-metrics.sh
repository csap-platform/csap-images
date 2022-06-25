source $CSAP_FOLDER/bin/csap-environment.sh
source $csapResourceFolder/common/mongo-helpers.sh


print_with_head "edit $csapResourceFolder/common/resize-metrics.sh and resize-metrics.js on $(hostname --short)" ;
print_line "Note: shutdown events service - process will take 30 minutes for 100gb" ;

exit 

scriptToRun=$csapResourceFolder/common/resize-metrics.js;
print_command \
  "Running script $scriptToRun " \
  "$(mongo_run_script $scriptToRun 'metricsDb')"
  
print_with_head "Delete oldMetrics " ; 

  
exit ;  

#
#   Running from bash is complicated
#


print_command \
  "CSAP Metrics Collections" \
  "$(mongo_run_command 'metricsDb' 'db.getCollectionNames() ')"
  

metricCappedCollectionSizeInGb=500 ;
metricCappedCollectionSizeInBytes=$(( $metricCappedCollectionSizeInGb * 1024 * 1024 * 1024 ))

print_with_head "Specified db is $metricCappedCollectionSizeInGb gb, and in bytes: $metricCappedCollectionSizeInBytes"

print_with_head "edit $csapResourceFolder/common/events-increase-size.sh on $(hostname --short)" ;
print_line "Note: shutdown events service - process will take 30 minutes for 100gb" ;

#exit ;



command="db.metrics.renameCollection('oldMetrics', true)"
print_command \
  "renaming metrics" \
  "$(mongo_run_command 'metricsDb' 'db.metrics.renameCollection("oldMetrics", true)' )"
exit
  
command='db.createCollection("metrics",{capped:true,size:'$metricCappedCollectionSizeInBytes'})'
print_command \
  "creating larger collection" \
  "$(mongo_run_command 'metricsDb' $command )"


command='db.oldMetrics.find().forEach(function (doc) {db.metrics.insert(doc)});'
print_command \
  "copying in old data" \
  "$(mongo_run_command 'metricsDb' $command )"
  

print_command \
  "CSAP Metrics Collections" \
  "$(mongo_run_command 'metricsDb' 'db.getCollectionNames()')" 
  
print_with_head "Delete oldMetrics, and indexes" ; 


exit


   




