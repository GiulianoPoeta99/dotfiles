# Función para gestionar paquetes con pacman
def pac [
    action?: string
    ...packages: string
] {
    match $action {
        "install" => { ^sudo pacman -S ...$packages },
        "update" => { ^sudo pacman -Syu },
        "remove" => { ^sudo pacman -R ...$packages },
        "autoremove" => { ^sudo pacman -Rns ...$packages },
        "search" => { ^pacman -Ss ...$packages },
        "show" => { ^pacman -Si ...$packages },
        "list" => { ^pacman -Qs ...$packages },
        "clean" => { ^sudo pacman -Sc },
        "full-upgrade" => { ^sudo pacman -Syyu },
        _ => { print $"Comando no reconocido: ($action)" }
    }
}

# Función para gestionar paquetes con paru/yay
def yay [
    action?: string
    ...packages: string
] {
    match $action {
        "install" => { ^paru -S ...$packages },
        "update" => { ^paru -Syu },
        "remove" => { ^paru -R ...$packages },
        "autoremove" => { ^paru -Rns ...$packages },
        "search" => { ^paru -Ss ...$packages },
        "show" => { ^paru -Si ...$packages },
        "list" => { ^paru -Qs ...$packages },
        "clean" => { ^paru -Sc },
        "full-upgrade" => { ^paru -Syyu },
        _ => { print $"Comando no reconocido: ($action)" }
    }
}