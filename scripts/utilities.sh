#!/bin/sh
set -e

YELLOw='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_section() {
  echo
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  printf "${YELLOW}[DOTFILES]${NC} $1\n"
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo
}

log() {
  printf "\n${BLUE}[DOTFILES]${NC} $1\n\n"
}

install_brew() {
  log "Installing $@ via brew"
  brew uninstall $1 &>/dev/null
  echo "$1 uninstalled"
  brew install -f $1
}

install_brew_cask() {
  log "Installing $1 via brew cask"
  brew uninstall --cask &>/dev/null
  echo "$1 uninstalled"
  brew install --cask -f $@
}

install_apt() {
  log "Installing $1 via apt"
  sudo apt-get uninstall $1 &>/dev/null
  echo "$1 uninstalled"
  sudo apt-get install -y $@
}

install_snap() {
  log "Installing $1 via snap"
  sudo snap remove $1 &>/dev/null
  echo "$1 uninstalled"
  sudo snap install $@
}
