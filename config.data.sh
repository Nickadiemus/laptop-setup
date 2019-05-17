#!/bin/bash
BREW=()
CASK=()

load_cask () {
  LENGTH=$(cat custom.config.json | jq '.cask .applications' | jq 'length')
  data=$(cat custom.config.json | jq '.cask .applications')
  data=${data// /}
  data=${data//,/}
  data=${data##[}
  data=${data%]}
  eval CASK=($data)
}

load_brew () {
  LENGTH=$(cat custom.config.json | jq '.brew .formulas' | jq 'length')
  data=$(cat custom.config.json | jq '.brew .formulas')
  data=${data// /}
  data=${data//,/}
  data=${data##[}
  data=${data%]}
  eval BREW=($data)
}

load_configs () {
  load_brew
  load_cask
}
