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
DATA="../config.data.sh"
# Vars
REQUIRED_UTILS=(cask jq wget)


# Helper function for formula installs
brew_install () {
  echo "$Purple Installing $1...$Color_Off"
  brew install $1
}

# Helper function for cask installs
brew_cask_install () {
  echo "$Purple Installing $1...$Color_Off"
  sudo apt install $1
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

# Installs basic repositories
install_basic () {
  clear
  echo "$GREEN Starting Basic Install...$Color_Off"
  for cask in "${MCASKB[@]}"; do
    brew_cask_install $cask
  done

  for formula in "${MBREWB[@]}"; do
    brew_install $formula
  done
  brew_clean
  echo "$GREEN Done $Color_Off"
  exit
}

# Installs custom configured repositories
install_custom () {
  clear
  load_custom_data
  echo "$GREEN Starting Custom Install...$Color_Off"
  for cask in "${MCASKC[@]}"; do
    brew_cask_install $cask
  done

  for formula in "${MBREWC[@]}"; do
    brew_install $formula
  done
  clean_brew
  echo "$GREEN Done $Color_Off"
  exit
}

# Installs Basic Brew Utilities used for setup
install_utils () {
    echo "t"
}

# Updates Homebrew
brew_update () {
  brew update
  brew outdated
  brew upgrade
}

# Cleans up old version of a formula
brew_clean () {
  echo "$Green Cleaning Dependencies $Color_Off"
  brew cleanup -n
  read -p "$(echo "$Green These are all the old formulas that would be clean. Would you like to continue? (y/n): $Color_Off")" uinput
  if [ $uinput == "y" ] || [ $uinput == "Y" ] || [ $uinput == "yes" ]; then
    brew cleanup
  fi
}

# Checks if the user already has required formulas
check_depend () {
  if [ $1 == "1" ]; then
    echo "Checking for dependencies..."
    for u in "${REQUIRED_UTILS[@]}"; do
      if [ -f "/usr/local/bin/$u" ]; then
        echo "$GREEN $u - Installed $Color_Off"
      else
        echo "$RED $u - Not Installed $Color_Off"
        brew_install $u
      fi
    done
  else
    for u in "${REQUIRED_UTILS[@]}"; do
      brew_install $u
    done
  fi
}

prompt () {
  clear
  while :
  do
    echo "Basic\tInstall\t\t(b)\nCustom\tInstall\t\t(c)\nUnistall Homebrew\t(u)\nQuit\t\t\t(exit)"
    read -p "What would you like to do? (PRESS ENTER): " REPLY
    case $REPLY in
      b) install_basic;;
      c) install_custom;;
      u) echo "Uninstalling Homebrew";;
      exit) exit;;
      *) echo "$(clear) $RED Invalid Choice - Try again $Color_Off";;
    esac
  done
}


startup () {
  clear
  echo "$Green Starting Setup... $Color_Off"
  echo "$Green Checking for homebrew... $Color_Off"
  sleep 1
  # Checks if homebrew is installed
  if [ -f "/usr/local/bin/brew" ]; then
    echo "$Green Instance of brew is already installed. $Color_Off"
    echo "$Green Updating/Installing formulas required for script... $Color_Off"
    sleep 1
    check_depend 1
    . $DATA      # Imports helper functions
    brew_update
    fetch_data
  else
    echo "$Green Instance of homebrew not found. Installing...$Color_Off"
    sleep 1
    install_prerequisites
    install_brew
    check_depend 0
    . $DATA      # Imports helper functions
    fetch_data
  fi
  prompt
}

startup
