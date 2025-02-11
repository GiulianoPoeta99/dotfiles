#!/bin/bash

hora=$(date +"%A %H:%M:%S")
fecha=$(date +"%d/%m/%Y")
bateria=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}')

notify-send -i "dialog-information" -t 5000 -u low "Status" "* Time: $hora\n* Date: $fecha\n* Battery: $bateria"
