#!/bin/bash

if [[ "$(~/.config/ags/widget/dialog/app.ts -a 'Log out')" == "yes" ]]; then
  hyprctl dispatch exit 
fi