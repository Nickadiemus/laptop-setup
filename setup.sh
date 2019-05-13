#!/bin/sh

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

install_prerequisites () {
  # Xcode Command Line Tool Installation
  xcode-select --install
}

install_brew () {
  # starts brew install
  /usr/bin/ruby -e "$(curl -fsSL $HOMEBREW)"

  # redundent check
  brew doctor
}

startup () {
  clear
  echo "$Green Starting Setup... $Color_Off"
  install_prerequisites
  install_brew


}

startup
