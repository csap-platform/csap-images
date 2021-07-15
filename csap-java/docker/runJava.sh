#!/bin/bash

function print_with_head() { 
	echo -e "$LINE \n  $* \n$LINE"; 
}

function print_with_date() { 
	echo -e "$LINE `date '+%x %H:%M:%S %Nms'` host: '$HOSTNAME' user: '$USER' \n $* \n$LINE"; 
}

function print_line() { 
	echo -e "   $*" ;
}


function print_json() {
#	{ "level": "WARN", "friendlyDate": "Now", "loggerFqcn": "org.SpringBoot", "message": "Service Started: Application: ${application.formatted-version} Boot: ${spring-boot.version}" }
	echo -e "{ \"level\": \"WARN\", \"friendlyDate\": \"Now\", \"loggerFqcn\": \"org.csap.java\", \"message\": \"$*\" }" ;
}
PATH="$JAVA_HOME/bin:${PATH}" \
print_json "Run user: `id` \n PATH: '$PATH'"

javaVersion=$(java -version 2>&1 | tail -1)
print_json "JAVA_HOME: '$JAVA_HOME' , java -version: '$javaVersion'"

print_json "JAVA_OPIONS: '$javaOptions'"

#startCommand=${startCommand:-java} ;
print_json "startCommand: '$startCommand' '$javaOptions'"

eval $startCommand $javaOptions $javaTarget

print_json "COMPLETE"

#bash -c "$startCommand"
#java $JAVA_OPTIONS
