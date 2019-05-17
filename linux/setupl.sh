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
CONFIG="./config/custom"

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
  echo "$Green Starting Install of Applications... $Color_Off"
  brew_cask_install google-chrome
  brew_cask_install firefox
  brew_cask_install iterm2
  brew_cask_install atom
  brew_cask_install adobe-creative-cloud
  brew_cask_install telegram
  brew_cask_install spotify
  brew_cask_install vlc
  brew_cask_install sequel-pro



  # Prgramming Languages
  clear
  echo "$Green Starting Install of Programming Languages... $Color_Off"
  brew_install "ruby"
  brew_install "python2"
  brew_install "python3"
  brew_cask_install "java"

  # Package Managers
  clear
  echo "$Green Starting Install of Package Managers... $Color_Off"
  brew_install "git"
  brew_install "yarn"
  brew_install "node"

  # Databases
  echo "$Green Starting Install of Package Managers... $Color_Off"
  brew_install "mysql"
  brew tap homebrew/services 
  brew services start mysql 
  brew_install "postgresql"
  brew_install "mongodb"

}

install_custom () {
  echo "Custom Install"
  source ./config.data.sh
  load_configs
  LENGTH=$(cat custom.config.json | jq '.brew .formulas' | jq 'length')
  for (( k = 0; k < $LENGTH; k++ )); do
    brew_install ${BREW[$k]}
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
  # install_brew_utils
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
