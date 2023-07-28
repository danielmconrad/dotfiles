#!/bin/sh

source $(chezmoi source-path)/utils.sh

log_section "Installing SSH"

# MacOS
# ==============================================================================
{{- if eq .chezmoi.os "darwin" -}}

touch ~/.ssh/config
echo "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa" > ~/.ssh/config
echo "Host github.com\n  Host github.com\n  Hostname ssh.github.com\n  Port 443" >> ~/.ssh/config

ssh-keygen -t ed25519 -C "daniel.m.conrad@gmail.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub
log "Public SSH key copied to clipboard"

{{ end -}}


# Linux
# ==============================================================================
{{- if eq .chezmoi.os "linux" -}}

touch ~/.ssh/config
echo "Host github.com\n  Host github.com\n  Hostname ssh.github.com\n  Port 443" >> ~/.ssh/config

ssh-keygen -t ed25519 -C "daniel.m.conrad@gmail.com" -f ~/.ssh/id_ed25519

{{ end -}}
