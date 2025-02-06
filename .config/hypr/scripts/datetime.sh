#!/bin/bash

fecha=$(date +"Fecha: %A | %d.%m.%Y")
hora=$(date +"Hora: %H:%M")

notify-send -i "dialog-information" -t 5000 -u low " " "\n$hora\n\n$fecha"
