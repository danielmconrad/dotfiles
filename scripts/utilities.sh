#!/bin/sh
set -e

YELLOw='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_section() {
  echo
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  printf "${YELLOW}[PROFILE]${NC} $1\n"
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo
}

log() {
  printf "${BLUE}[PROFILE]${NC} $1\n"
}

install_brew() {
  log "Installing $@ via brew"
  brew uninstall $1 || echo "$1 uninstalled"
  brew install -f $1
}

install_brewmake_cask() {
  log "Installing $@ via brew cask"
  brew uninstall --cask $1 || echo "$1 uninstalled"
  brew install --cask -f $1
}

install_apt() {
  log "Installing $@ via apt"
  sudo apt-get uninstall $@ || echo "$@ uninstalled"
  sudo apt-get install -y $@
}

install_snap() {
  log "Installing $@ via snap"
  sudo snap uninstall $@ || echo "$@ uninstalled"
  sudo snap install $@
}
