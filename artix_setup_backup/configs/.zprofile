if [[ -z $DISPLAY ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
  export XDG_SESSION_TYPE=wayland
  export XDG_CURRENT_DESKTOP=sway

  if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
  fi

  pgrep -u "$USER" runsvdir > /dev/null || runsvdir -P ~/.local/etc/runit/user-services &

  pgrep -x sway > /dev/null || exec sway
fi
