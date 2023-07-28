#!/bin/sh
set -e

YELLOw='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

install_apt() {
  sudo apt-get uninstall $@ || echo "$@ uninstalled"
  sudo apt-get install $@
}

install_brew() {
  brew uninstall $1 || echo "$1 uninstalled"
  brew install -f $1
}

install_brew_cask() {
  brew uninstall --cask $1 || echo "$1 uninstalled"
  brew install --cask -f $1
}

install_snap() {
  sudo snap uninstall $@ || echo "$@ uninstalled"
  sudo snap install $@
}

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
