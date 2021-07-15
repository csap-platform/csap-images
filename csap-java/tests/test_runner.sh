#!/bin/bash

# $1 = run output logs

# check changes to the script
java_version_out=$(grep "OpenJDK 64-Bit Server VM" $1)
if [[ -z $java_version_out ]]; then
   echo "Failed to find java -version output"
   exit 1
fi
