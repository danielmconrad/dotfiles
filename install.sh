#!/bin/sh

if [ $(uname -s) = "Darwin" ]; then
  if [ ! -e $(xcode-select --print-path &> /dev/null) ]; then xcode-select --install &> /dev/null; fi
  until [ -e $(xcode-select --print-path &> /dev/null) ]; do sleep 5; done
fi

if [ command -v wget &> /dev/null ]; then
  sh -c "$(wget -qO- get.chezmoi.io)" -- init --apply danielmconrad
else
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply danielmconrad
fi
