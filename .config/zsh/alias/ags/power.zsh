off() {
  if [[ "$(~/.config/ags/widget/dialog/app.ts -a Shutdown)" == "yes" ]]; then
    shutdown now
  fi
}

restart() {
  if [[ "$(~/.config/ags/widget/dialog/app.ts -a Restart)" == "yes" ]]; then
    reboot now
  fi
}

