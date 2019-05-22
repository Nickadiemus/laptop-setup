#!/bin/bash

# Vars
CONFIGPATH=../custom.config.json
ARR_VARS=(UTILS MBREWC MCASKC MBREWB MCASKB LBREWC LAPTC LBREWB LAPTB)
DELIMITER=","
UTILS=$(cat $CONFIGPATH | jq -c '.utils' | tr -d '[]')
# OSX Arrays
MBREWC=$(cat $CONFIGPATH | jq -c '.mac .custom .formulas' | tr -d '[]')
MCASKC=$(cat $CONFIGPATH | jq -c '.mac .custom .applications' | tr -d '[]')
MBREWB=$(cat $CONFIGPATH | jq -c '.mac .basic .formulas' | tr -d '[]')
MCASKB=$(cat $CONFIGPATH | jq -c '.mac .basic .applications' | tr -d '[]')
# Linux Arrays
LBREWC=$(cat $CONFIGPATH | jq -c '.linux .custom .formulas' | tr -d '[]')
LAPTC=$(cat $CONFIGPATH | jq -c '.linux .custom .apt' | tr -d '[]')
LBREWB=$(cat $CONFIGPATH | jq -c '.linux .basic .formulas' | tr -d '[]')
LAPTB=$(cat $CONFIGPATH | jq -c '.linux .basic .apt' | tr -d '[]')


# Helper function
array_delimiter () {
  local IFS=$2        #delimiter
  eval $1\=\(${!1}\)
}

# creates the custom config arrays
fetch_data () {
  for var in "${ARR_VARS[@]}"; do
    array_delimiter $var $DELIMITER
  done
}

# Debug Function
print_arr () {
  arr=("$@")
  for item in "${arr[@]}"; do
    echo $item
  done
}
