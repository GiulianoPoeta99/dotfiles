#!/bin/bash

# Verificar si el monitor Samsung está conectado
if hwinfo --monitor | grep -q "SAMSUNG LF24T35"; then
	# echo "Monitor Samsung detectado. Ejecutando comando xrandr..."

	# Ejecutar el comando xrandr
	xrandr --output HDMI-1-0 --mode 1920x1080 --above eDP-1
	xrandr --output HDMI-1-0 --rotate inverted

	# echo "Comando xrandr ejecutado."
else
	# Verificar si hay algún otro monitor conectado a través de HDMI
	if hwinfo --monitor | grep -q "#9 (VGA compatible controller)"; then
		# echo "Otro monitor HDMI detectado. Ejecutando comando xrandr..."

		# Ejecutar el comando xrandr para otro monitor HDMI
		xrandr --output HDMI-1-2 --auto --above eDP-1

		# echo "Comando xrandr ejecutado."
		#else
		# echo "No se detecto el monitor Samsung ni nada conectado al HDMI."
	fi
fi
