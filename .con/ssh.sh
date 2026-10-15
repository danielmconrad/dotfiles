
# Describes this machine's SSH key, e.g.
#   daniel.conrad@JXGF6YK2F5 · MacBook Pro · macOS 26.6.2 arm64 · 2026-10-15
# The user and host tell machines and accounts apart, the model is what you'd
# recognize, and the date separates keys from reinstalls of one machine.
ssh_key_label() {
  if [ "$(uname -s)" = "Darwin" ]; then
    device="$(system_profiler SPHardwareDataType 2> /dev/null | awk -F ': ' '/Model Name/ { print $2 }')"
    system="macOS $(sw_vers -productVersion)"
  else
    device="$(cat /sys/devices/virtual/dmi/id/product_name 2> /dev/null || echo Linux)"
    system="$(. /etc/os-release && echo "$PRETTY_NAME")"
  fi

  echo "$(whoami)@$(hostname -s) · $device · $system $(uname -m) · $1"
}
