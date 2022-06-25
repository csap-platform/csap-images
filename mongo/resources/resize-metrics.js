

print("\n\n renaming collection" ) ;

db.metrics.renameCollection("oldMetrics", true);

var numGb=500
var GBytes=1024*1024*1024 ;
print("\n\n creating metricCappedCollectionSizeInBytes: " + numGb*GBytes) ;
db.createCollection( "metrics", { capped: true, size: numGb*GBytes } );


print("\n\n Adding indexes" ) ;
//creates index with specified values. background true helps in not stopping all other operations
db.metrics.createIndex({"attributes.hostName":1,"attributes.id":1,"createdOn.lastUpdatedOn":-1},{ background: true });
db.metrics.createIndex({"attributes.hostName":1,"createdOn.date":1},{ background: true });
db.metrics.createIndex({"createdOn.date":1},{ background: true });


print("\n\n Copying in data from oldMetrics to new metrics" ) ;
db.oldMetrics.find().forEach(function (doc) {db.metrics.insert(doc)});

print("\n\n USER MUST DELETE oldMeterics \n\n" ) ;
//  db.oldMetrics.drop() ;

