#!/bin/bash

# $1 = run output logs

# check changes to the script
java_version_out=$(grep "Started Csap_Tester_Application" $1) ;
if [[ -z $java_version_out ]]; then
   echo "Failed to find required output"
   exit 1
fi
