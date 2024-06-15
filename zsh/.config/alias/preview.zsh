

# Función para determinar si una entrada es un directorio o un archivo
preview() {
    if [ -d "$1" ]; then
        eza -al --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos "$1"
    elif [ -f "$1" ]; then
        batcat --color=always "$1"
    else
        echo "Entrada no válida: $1"
    fi
}

# Obtener la ruta real del argumento
realpath=$(realpath "$1")

# Ejecutar la función preview con el argumento
preview "$realpath"
