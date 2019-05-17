#!/bin/bash

# Welcome to my personal laptop setup
# This is a simple script that will install basic utilities for your laptop (or Desktop)
# Feel free to use/edit it at your disposal
# Author -  Nick Sladic
# Website - https://nicksladic.me
# Github -  nickadiemus

# Reset
Color_Off='\033[0m'       # Text Reset

# Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Purple='\033[0;35m'       # Purple
Blue='\033[0;34m'         # Blue

# Repositories
HOMEBREW="https://raw.githubusercontent.com/Homebrew/install/master/install"
GITHOMEBREW="https://github.com/Homebrew/brew/tarball/master"

# Paths
LOCAL="/usr/local"
LBIN="/usr/local/bin"
CONFIG="../custom.config.json"
source ../config.data.sh

brew_install () {
  echo "$Purple Installing $1...$Color_Off"
  brew install $1
}

brew_cask_install () {
  echo "$Purple Installing $1...$Color_Off"
  brew cask install $1
}

# Installs Prerequisites for setup
install_prerequisites () {
  # Xcode Command Line Tool Installation
  xcode-select --install
}

# Installs Homebrew
install_brew () {
  # starts brew install
  /usr/bin/ruby -e "$(curl -fsSL $HOMEBREW)"
  # redundent check
  brew doctor
}

install_basic () {
  clear
  load_basic_data
  LENGTH=$(cat $CONFIG | jq '.basic .formulas' | jq 'length')
  for (( k = 0; k < $LENGTH; k++ )); do
    brew_install ${BREWB[$k]}
  done

  LENGTH=$(cat $CONFIG | jq '.basic .applications' | jq 'length')
  for (( l = 0; l < $LENGTH; l++ )); do
    brew_cask_install ${CASKB[$l]}
  done
}


install_custom () {
  clear
  load_custom_data
  LENGTH=$(cat $CONFIG | jq '.brew .formulas' | jq 'length')
  for (( k = 0; k < $LENGTH; k++ )); do
    brew_install ${BREWC[$k]}
  done

  LENGTH=$(cat $CONFIG | jq '.cask .applications' | jq 'length')
  for (( l = 0; l < $LENGTH; l++ )); do
    brew_cask_install ${CASKC[$l]}
  done
}

# Installs Basic Brew Utilities
install_brew_utils () {
  brew_install "cask"
  brew_install "wget"
  brew_install "nmap"
  brew_install "jq"
}


startup () {
  clear
  echo "$Green Starting Setup... $Color_Off"
  # install_prerequisites
  # install_brew
  install_brew_utils
  echo 'What would you like to proceed with?
Basic   Install   (b)
Custom  Install   (c)
Exit              (exit)'
  read -p "$USER: " installchoice

  if [ $installchoice == "b" ]; then
    install_basic
  elif [ $installchoice == "c" ]; then
    install_custom
  elif [ $installchoice == "exit" ]; then
    clear
    exit
  else
    echo -e "$Red Invalid Choice $Color_Off"
    sleep 1
    startup
  fi
  # install_basic
}

startup
