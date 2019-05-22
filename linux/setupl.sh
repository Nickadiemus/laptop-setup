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
REQUIRED_UTILS=(jq wget)

brew_install () {
  echo -e "$Purple Installing $1...$Color_Off"
  brew install $1
}

apt_install () {
  echo -e "$Purple Installing $1...$Color_Off"
  sudo apt install $1
}


# Installs Prerequisites for setup
install_prerequisites () {

    if [ -f "/etc/os-release" ]; then

      #Ubuntu
      echo -e "DEBUG: inside /etc/os-release"
      sudo apt-get install build-essential curl file git
      . /etc/os-release
      install_brew $NAME $VERSION_ID

    elif [ -f "/etc/lsb-release" ]; then

      echo -e "DEBUG: inside /etc/lsb-release"
      #Some versions of Ubuntu/Debian without the lsb_release command
      sudo apt-get install build-essential curl file git
      . /etc/lsb-release
      install_brew $DISTRIB_ID $DISTRIB_RELEASE

    elif type lsb_release >/dev/null 2>&1; then

      #Linux CentOS,Fedora, etc.
      echo -e "DEBUG: inside lsb_release"
      sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
      install_brew $(lsb_release -si) $(lsb_release -sr)


    elif [ -f /etc/debian_version ]; then

      echo -e "DEBUG: inside /etc/debian_version"
      #Older versions of Ubuntu/Debian
      sudo apt-get install build-essential curl file git
      install_brew "Debian" $(cat /etc/debian_version)

    elif [ -f /etc/redhat-release ]; then

      echo -e "DEBUG: inside /etc/redhat-release"
      #Redhat
      sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
      install_brew "Redhat" ""
    else
      install_brew "$(uname -s) $(uname -r)"
    fi
}

# Updates Homebrew
brew_update () {
  brew update
  brew outdated
  brew upgrade
}

# Installs Homebrew
install_brew () {

  # starts brew install
  # sh -c "$(curl -fsSL $HOMEBREW)"
  # test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  # test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  sudo apt install linuxbrew-wrapper
  brew --help
  #Adds brew to $PATH variable
  # if [[ "$1" = "Ubuntu" ]] || [[ "$1" = "Debian" ]]; then
  #
  #   echo -e "$BLUE Adding brew to your PATH variable...$Color_Off"
  #   if [ -f ~/.zshrc ]; then
  #     PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  #     echo -e "export PATH=/home/linuxbrew/.linuxbrew/Homebrew/bin:$PATH" >>~/.zshrc  && . ~/.zshrc
  #    else
  #      PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  #      echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.zprofile
  #      echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.zprofile
  #      echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.zprofile
  #      echo -e "export PATH=/home/linuxbrew/.linuxbrew/Homebrew/bin:$PATH" >>~/.profile && . ~/.profile
  #   fi
  #
  # elif [[ "$1" = "Fedora" ]] || [[ "$1" = "CentOS" ]] || [[ "$1" = "Redhat" ]]; then
  #
  #   echo -e "$BLUE Adding brew to yobbur PATH variable...$Color_Off"
  #   #if you have oh-my-zsh installed
  #   if [ -f ~/.zshrc ]; then
  #     PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  #     echo -e "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zshrc  && . ~/.zshrc
  #   else
  #     echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.zprofile
  #     echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.zprofile
  #     echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.zprofile
  #     test -r ~/.bash_profile && echo -e "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile && . ~/.bash_profile
  #   fi
  # else
  #
  #   echo -e "$RED Error: 001 - brew could not be added to PATH variable.$Color_Off"
  #   echo -e "Terminating.."
  #   exit
  # fi

  brew doctor
}

# Cleans up old version of a formula
brew_clean () {
  echo -e "$Green Cleaning Dependencies $Color_Off"
  brew cleanup -n
  read -p "$(echo -e "$Green These are all the old formulas that would be clean. Would you like to continue? (y/n): $Color_Off")" uinput
  if [ $uinput == "y" ] || [ $uinput == "Y" ] || [ $uinput == "yes" ]; then
    brew cleanup
  fi
}

# Installs general set of packages
install_basic () {
  clear
  echo -e "$GREEN Starting Basic Install...$Color_Off"
  for formula in "${LBREWB[@]}"; do
    brew_install $formula
  done
  for apt in "${LAPTB[@]}"; do
    apt_install $apt
  done
  brew_clean
  echo -e "$GREEN Done $Color_Off"
  exit
}

# Installs via config file
install_custom () {
  clear
  echo -e "$GREEN Starting Custom Install...$Color_Off"
  for formula in "${LBREWC[@]}"; do
    brew_install $formula
  done
  for apt in "${LAPTC[@]}"; do
    apt_install $apt
  done
  brew_clean
  echo -e "$GREEN Done $Color_Off"
  exit
}

# Installs Basic Brew Utilities
install_brew_utils () {
  brew_install "wget"
  brew_install "nmap"
  brew_install "jq"
}

# Checks if the user already has required formulas
check_depend () {
  if [ $1 == "1" ]; then
    echo -e "Checking for dependencies..."
    for u in "${REQUIRED_UTILS[@]}"; do
      if [ -f "/usr/local/bin/$u" ] || [ -f "/usr/bin/$u" ]; then
        echo -e "$GREEN $u - Installed $Color_Off"
      else
        echo -e "$RED $u - Not Installed $Color_Off"
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
    echo -e "Basic\tInstall\t\t(b)\nCustom\tInstall\t\t(c)\nUnistall Homebrew\t(u)\nQuit\t\t\t(exit)"
    read -p "What would you like to do? (PRESS ENTER): " REPLY
    case $REPLY in
      b) install_basic;;
      c) install_custom;;
      u) echo -e "Uninstalling Homebrew";;
      exit) exit;;
      *) echo -e "$(clear) $RED Invalid Choice - Try again $Color_Off";;
    esac
  done
}

startup () {
  clear
  echo -e "$Green Starting Setup... $Color_Off"
  echo -e "$Green Checking for homebrew... $Color_Off"
  sleep 1
  # Checks if homebrew is installed
  if [ -f "/usr/local/bin/brew" ] || [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    echo -e "$Green Instance of brew is already installed. $Color_Off"
    echo -e "$Green Updating/Installing formulas required for script... $Color_Off"
    sleep 1
    check_depend 1
    . $DATA      # Imports helper functions
    brew_update
    fetch_data
  else
    echo -e "$Green Instance of homebrew not found. Installing...$Color_Off"
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
