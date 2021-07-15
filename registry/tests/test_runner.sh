#!/bin/bash

# $1 = run output logs

# check to see if we get a response back from the registry.
catalog=`curl -X GET http://localhost:5111/v2/_catalog`
if [[ -z $catalog ]]; then
   exit 1
fi
