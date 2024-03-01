#!/bin/sh
set -e

{{ include "logger.sh" }}

install_apt() {
  log "Installing $@ via apt"
  sudo apt-get uninstall $@ || echo "$@ uninstalled"
  sudo apt-get install $@
}

install_brew() {
  log "Installing $@ via brew"
  brew uninstall $1 || echo "$1 uninstalled"
  brew install -f $1
}

install_brew_cask() {
  log "Installing $@ via brew cask"
  brew uninstall --cask $1 || echo "$1 uninstalled"
  brew install --cask -f $1
}

install_snap() {
  log "Installing $@ via snap"
  sudo snap uninstall $@ || echo "$@ uninstalled"
  sudo snap install $@
}

