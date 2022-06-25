print("\n\n Setting slave ok") ;
rs.secondaryOk() ;


print("\n\n Updating profiling slow query setting to 1000ms") ;
printjson( db.setProfilingLevel(0, { slowms: 1000 }) );
printjson( db.getProfilingStatus() );



print("\n\n First 2 records in a date range") ;
printjson( db.eventRecords.find({"createdOn.date":{$gte:"2021-01-01"}}).limit(2).toArray() );


print("\n\n Exiting") ;
quit() ;


print("\n\n First 5 records starting with /csap" ) ;
printjson(
	db.eventRecords.find({ 
	    category: { $regex: /^\/csap\/ui/ }, 
	    "metaData.uiUser": "peter.nightingale", 
	    "createdOn.date": { $gte: "2016-04-04", $lt: "2016-04-12" }
	    })
	 .limit(5)
	.toArray()
) ;


print("\n\n Explain plan for query" ) ;

printjson( db.eventRecords
	.find({ 
	    category: { $regex: /^\/csap\/ui/ }, 
	    "metaData.uiUser": "peter.nightingale", 
	    "createdOn.date": { $gte: "2016-04-04", $lt: "2016-04-12" }
	    })
	.explain("executionStats")
) ;





print("\n\n Trending query" ) ;

printjson( db.eventRecords
	.find({ 
	    category: { $regex: /^\/csap\/ui/ }, 
	    "metaData.uiUser": "peter.nightingale", 
	    "createdOn.date": { $gte: "2016-04-04", $lt: "2016-04-12" }
	    })
	.explain("executionStats")
) ;








