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
  if brew list --formula "$1" >/dev/null 2>&1; then
    log "$1 is already installed, skipping"
    return
  fi
  log "Installing $@ via brew"
  brew install $@
}

reinstall_brew() {
  log "Reinstalling $@ via brew"
  brew uninstall $1 >/dev/null 2>&1 || true
  brew install -f $@
}

# True if Homebrew installed the cask, or its app is already in place some other
# way, such as by an MDM like Kandji, which macOS won't let Homebrew overwrite.
brew_cask_installed() {
  brew list --cask "$1" >/dev/null 2>&1 && return 0
  command -v jq >/dev/null 2>&1 || return 1
  brew info --cask --json=v2 "$1" 2>/dev/null \
    | jq -r '.casks[].artifacts[] | .app? // empty | .[] | if type == "string" then . else .target // empty end' \
    | (
        while IFS= read -r app; do
          [ -e "/Applications/$app" ] && exit 0
          [ -e "$HOME/Applications/$app" ] && exit 0
        done
        exit 1
      )
}

install_brew_cask() {
  if brew_cask_installed "$1"; then
    log "$1 is already installed, skipping"
    return
  fi
  log "Installing $1 via brew cask"
  brew install --cask $@
}

reinstall_brew_cask() {
  log "Reinstalling $1 via brew cask"
  brew uninstall --cask $1 >/dev/null 2>&1 || true
  brew install --cask -f $@
}

# Starts a Homebrew service unless it's already running. Pass --root for
# services that run as root, which brew only reports correctly under sudo.
start_brew_service() {
  as=""
  if [ "$2" = "--root" ]; then
    as="sudo"
  fi
  if $as brew services info "$1" --json 2>/dev/null | grep -q '"running": true'; then
    log "$1 service is already running, skipping"
    return
  fi
  log "Starting $1 service"
  $as brew services start "$1"
}

install_apt() {
  log "Installing $1 via apt"
  sudo apt-get uninstall $1 &>/dev/null || true
  sudo apt-get install -y $@
}

install_snap() {
  log "Installing $1 via snap"
  sudo snap remove $1 &>/dev/null || true
  sudo snap install $@
}
