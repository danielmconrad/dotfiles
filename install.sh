#!/bin/sh

if [ $(uname -s) = "Darwin" ]; then
  if [ "$(xcode-select --print-path 2> /dev/null)" = "" ]; then xcode-select --install &> /dev/null; fi
  printf "Waiting for XCode Command Line Tools to be installed..."
  until [ "$(xcode-select --print-path 2> /dev/null)" != "" ]; do sleep 5; printf '.'; done
  echo ""
fi

if [ command -v wget &> /dev/null ]; then
  sh -c "$(wget -qO- get.chezmoi.io)" -- init --apply danielmconrad
else
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply danielmconrad
fi
