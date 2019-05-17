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


brew_install () {
  echo -e "$Purple Installing $1...$Color_Off"
  brew install $1
}

brew_cask_install () {
  echo -e "$Purple Installing $1...$Color_Off"
  brew cask install $1
}

# Installs Prerequisites for setup
install_prerequisites () {
    if [ -f "/etc/os-release" ]; then
      
      #Ubuntu
      echo "DEBUG: inside /etc/os-release"
      sudo apt-get install build-essential curl file git 
      . /etc/os-release
      install_brew $NAME $VERSION_ID
    
    elif [ -f "/etc/lsb-release" ]; then
      
      echo "DEBUG: inside /etc/lsb-release"
      #Some versions of Ubuntu/Debian without the lsb_release command
      sudo apt-get install build-essential curl file git 
      . /etc/lsb-release
      install_brew $DISTRIB_ID $DISTRIB_RELEASE
      
    elif type lsb_release >/dev/null 2>&1; then
      
      #Linux CentOS,Fedora, etc.
      echo "DEBUG: inside lsb_release"
      sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
      install_brew $(lsb_release -si) $(lsb_release -sr)
    
      
    elif [ -f /etc/debian_version ]; then
      
      echo "DEBUG: inside /etc/debian_version"
      #Older versions of Ubuntu/Debian
      sudo apt-get install build-essential curl file git
      install_brew "Debian" $(cat /etc/debian_version)
    
    elif [ -f /etc/redhat-release ]; then
      
      echo "DEBUG: inside /etc/redhat-release"
      #Redhat  
      sudo yum groupinstall 'Development Tools' && sudo yum install curl file git
      install_brew "Redhat" ""
    else
      install_brew "$(uname -s) $(uname -r)"
    fi
}


# Installs Homebrew
install_brew () {
  
  # starts brew install
  sh -c "$(curl -fsSL $HOMEBREW)"
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  
  #Adds brew to PATH variable
  if [[ "$1" = "Ubuntu" ]] || [[ "$1" = "Debian" ]]; then
    
    echo -e "$BLUE Adding brew to your PATH variable...$Color_Off"
    if [ -f ~/.zshrc ]; then
      echo "export PATH=/home/linuxbrew/.linuxbrew/Homebrew/bin:$PATH" >>~/.zshrc  && . ~/.zshrc 
     else
      echo "export PATH=/home/linuxbrew/.linuxbrew/Homebrew/bin:$PATH" >>~/.profile && . ~/.profile
    fi
  
    
  elif [[ "$1" = "Fedora" ]] || [[ "$1" = "CentOS" ]] || [[ "$1" = "Redhat" ]]; then
  
    echo -e "$BLUE Adding brew to yobbur PATH variable...$Color_Off"
    #if you have oh-my-zsh installed
    if [ -f ~/.zshrc ]; then
      echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zshrc  && . ~/.zshrc 
    else
      test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile && . ~/.bash_profile
    fi
    
  else
    
    echo -e "$RED Error: 001 - brew could not be added to PATH variable.$Color_Off"
    echo "Terminating.."
    exit 
    
  fi
  
  brew doctor
}

# Installs general set of packages
install_basic () {
  clear
  echo -e "$Green Starting Install of Applications... $Color_Off"
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
  echo -e "$Green Starting Install of Programming Languages... $Color_Off"
  brew_install "ruby"
  brew_install "python2"
  brew_install "python3"
  brew_cask_install "java"

  # Package Managers
  clear
  echo -e "$Green Starting Install of Package Managers... $Color_Off"
  brew_install "git"
  brew_install "yarn"
  brew_install "node"

  # Databases
  echo -e "$Green Starting Install of Package Managers... $Color_Off"
  brew_install "mysql"
  brew tap homebrew/services 
  brew services start mysql 
  brew_install "postgresql"
  brew_install "mongodb"

}

# Installs via config file
install_custom () {
  echo "Custom Install"
  . $CONFIG
  load_configs
  LENGTH=$(cat $CONFIG | jq '.brew .formulas' | jq 'length')
  for (( k = 0; k < $LENGTH; k++ )); do
    brew_install ${BREW[$k]}
  done
  
  LENGTH=$(cat $CONFIG | jq '.cask .applications' | jq 'length')
  for (( l = 0; l < $LENGTH; l++ )); do
    brew_install ${CASK[$l]}
  done


}

# Installs Basic Brew Utilities
install_brew_utils () {
  brew_install "wget"
  brew_install "nmap"
  brew_install "jq"
}


startup () {
  clear
  echo -e "$Green Starting Setup... $Color_Off"
  install_prerequisites
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
