#!/bin/sh

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
