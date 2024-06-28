#!/bin/bash

# Verificar si el monitor Samsung está conectado
if hwinfo --monitor | grep -q "SAMSUNG LF24T35"; then
	echo "Monitor Samsung detectado. Ejecutando comando xrandr..."
	# Ejecutar el comando xrandr
	xrandr --output HDMI-1-0 --mode 1920x1080 --above eDP-1 && xrandr --output HDMI-1-0 --rotate inverted
	echo "Comando xrandr ejecutado."
fi
