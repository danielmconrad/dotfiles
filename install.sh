#!/bin/sh

sudo echo ""

if [ $(uname -s) = "Darwin" ]; then
  printf "Waiting for XCode Command Line Tools to be installed..."
  
  if [ "$(xcode-select --print-path 2> /dev/null)" = "" ]; then 
    xcode-select --install &> /dev/null
  fi
  
  until [ "$(xcode-select --print-path 2> /dev/null)" != "" ]; 
    do sleep 5; printf '.'; 
  done
fi

if [ command -v wget &> /dev/null ]; then
  sh -c "$(wget -qO- get.chezmoi.io)" -- init --apply danielmconrad
else
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply danielmconrad
fi
