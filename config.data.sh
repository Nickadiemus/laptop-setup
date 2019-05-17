#!/bin/bash
BREWC=()
CASKC=()
BREWC=()
CASKB=()


load_cask () {
  data=$(cat ../custom.config.json | jq '.cask .applications')
  data=${data// /}
  data=${data//,/}
  data=${data##[}
  data=${data%]}
  eval CASKC=($data)
}

load_brew () {
  data=$(cat ../custom.config.json | jq '.brew .formulas')
  data=${data// /}
  data=${data//,/}
  data=${data##[}
  data=${data%]}
  eval BREWC=($data)
}

load_basic () {
  data=$(cat ../custom.config.json | jq '.basic .applications')
  data=${data// /}
  data=${data//,/}
  data=${data##[}
  data=${data%]}
  eval CASKB=($data)

  data=$(cat ../custom.config.json | jq '.basic .formulas')
  data=${data// /}
  data=${data//,/}
  data=${data##[}
  data=${data%]}
  eval BREWB=($data)
}

load_custom_data () {
  load_brew
  load_cask
}

load_basic_data () {
  load_basic
}
