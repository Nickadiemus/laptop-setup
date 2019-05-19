#!/bin/bash

# Vars
CONFIGPATH=../custom.config.json
ARR_VARS=(UTILS BREWC CASKC BREWB CASKB)
DELIMITER=","
UTILS=$(cat $CONFIGPATH | jq -c '.utils' | tr -d '[]')
BREWC=$(cat $CONFIGPATH | jq -c '.brew .formulas' | tr -d '[]')
CASKC=$(cat $CONFIGPATH | jq -c '.cask .applications' | tr -d '[]')
BREWB=$(cat $CONFIGPATH | jq -c '.basic .formulas' | tr -d '[]')
CASKB=$(cat $CONFIGPATH | jq -c '.basic .applications' | tr -d '[]')

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
