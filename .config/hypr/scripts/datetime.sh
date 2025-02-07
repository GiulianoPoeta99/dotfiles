#!/bin/bash

fecha=$(date +"%A %H:%M:%S | %d/%m/%Y")

notify-send -i "dialog-information" -t 5000 -u low "$fecha"
