#!/bin/bash

if [[ "$(~/.config/ags/widget/dialog/app.ts -a Restart)" == "yes" ]]; then
    pkexec reboot now
fi
