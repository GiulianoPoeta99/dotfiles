import subprocess
import os
from distros import DistroInstallerStrategy


class ArchInstaller(DistroInstallerStrategy):
    def update_system(self):
        print("Actualizando Arch Linux...")
        subprocess.run(["sudo", "pacman", "-Syu", "--noconfirm"], check=True)
        print("Actualizando lista de mirrors...")
        subprocess.run(["sudo", "pacman", "-S", "--noconfirm", "reflector"], check=True)
        subprocess.run(["sudo", "reflector", "--verbose", "--latest", "10", "--protocol", "https", "--sort", "rate", "--save", "/etc/pacman.d/mirrorlist"], check=True)
        print("Actualización finalizada.\n")


    def __flatten_packages(self,pkg_dict):
            flat_list = []
            for value in pkg_dict.values():
                if isinstance(value, list):
                    flat_list.extend(value)
                elif isinstance(value, dict):
                    flat_list.extend(self.__flatten_packages(value))
            return flat_list

    def install_packages(self):
        print("Instalando paquetes en Arch Linux...")

        result = subprocess.run(['command', '-v', 'paru'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if result.returncode != 0:
            print("'paru' no está instalado. Procediendo con la instalación...")
            try:
                repo_dir = os.path.expanduser("~/.repositories")
                paru_dir = os.path.join(repo_dir, "paru-bin")

                os.makedirs(repo_dir, exist_ok=True)

                print(f"Clonando 'paru-bin' en {repo_dir}...")
                subprocess.run(['git', 'clone', 'https://aur.archlinux.org/paru-bin.git'], cwd=repo_dir, check=True)

                print("Compilando e instalando 'paru'...")
                subprocess.run(['makepkg', '-si', '--noconfirm'], cwd=paru_dir, check=True)

                print("'paru' se instaló correctamente.")
            except subprocess.CalledProcessError as e:
                print(f"Error al instalar 'paru': {e}")
                return
        else:
            print("'paru' ya está instalado.")
        
        packages = {
            'pacman': {
                'base': ["bash-completion", "man-db", "man-pages", "xclip", "stow", 'glow'],
                'dev': {
                    'tools': {
                        'vim': ['neovim', 'ripgrep', 'fd', 'lazygit'],
                        'shell': ['zsh', 'nushell', 'tmux', 'starship', 'fzf', 'zoxide', 'eza', 'onefetch', 'fastfetch', 'bashtop', 'bat', 'atuin', 'thefuck', 'tokei', 'kondo', 'sd'],
                        'env': ['podman']
                    },
                    'langs': {
                        'python': ['python', 'python-pip', 'python-pipx'],
                        'go': ['go'],
                        'php': ['php', 'composer'],
                        'java': ['jdk23-openjdk', 'maven', 'gradle'],
                        'lua': ['lua', 'luarocks'],
                        'zig': ['zig'],
                        'nim': ['nim'],
                        'crystal': ['crystal', 'shards'],
                        'dart': ['dart'],
                        'c': ['clang'],
                        'make': ['just']
                    }
                },
                'apps': ['discord', 'spotify-launcher'],
                'desktop': ['hyprland'],
                'system': ['cups', 'gutenprint', 'foomatic-db', 'foomatic-db-engine', "foomatic-db-nonfree", 'hplip', 'splix', "cups-pdf", 'system-config-printer', 'avahi', "nss-mdns"]
            },
            'aur': {
                'base': ['ttf-cascadia-code-nerd'],
                'dev': {
                    'tools': ['lazydocker', 'tmuxinator',],
                    'dart': ['flutter'],
                    'gleam': ['gleam'],
                    'ruby': ['rvm']
                },
                'apps': ['brave-bin, zen-browser-bin', 'visual-studio-code-bin'],
                'desktop': ['hyprshot', 'hyprlock', 'hypridle', 'hyprpaper', 'hyprpicker', 'hyprpolkitagent', 'aylurs-gtk-shell']
            }
        }
        subprocess.run(["sudo", "pacman", "-S", "--noconfirm"] + self.__flatten_packages(packages['pacman']), check=True)
        subprocess.run(["paru", "-S", "--noconfirm"] + self.__flatten_packages(packages['aur']), check=True)

        subprocess.run(['pipx', 'install', 'poetry'], check=True)
        subprocess.run(['pipx', 'install', 'uv'], check=True)
        
        subprocess.run(['curl', '--proto', '=https', '--tlsv1.2', '-sSf', 'https://sh.rustup.rs', '|', 'sh'], shell=True, check=True)
        cargo_env = os.path.expanduser("~/.cargo/env")
        subprocess.run(['source', cargo_env], shell=True, executable='/bin/bash')
        subprocess.run(['rustup', 'update'], check=True)

        subprocess.run(['curl', '-o-', 'https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh', '|', 'bash'], shell=True, check=True)
        nvm_dir = os.path.expanduser("~/.nvm/nvm.sh")
        subprocess.run(['source', nvm_dir], shell=True, executable='/bin/bash')
        subprocess.run(['nvm', 'install', '22'], shell=True, executable='/bin/bash')
        subprocess.run(['corepack', 'enable', 'pnpm'], shell=True, executable='/bin/bash')
        subprocess.run(['corepack', 'enable', 'yarn'], shell=True, executable='/bin/bash')

        docker_version = input("Ingrese la versión de Docker (ej. 27.3.1): ")
        docker_path = input("Ingrese la ruta del archivo docker-desktop (ej. ./docker-desktop-x86_64.pkg.tar.zst): ")
        subprocess.run(f"wget https://download.docker.com/linux/static/stable/x86_64/docker-{docker_version}.tgz -qO- | tar xvfz - docker/docker --strip-components=1", shell=True, check=True)
        subprocess.run("sudo mv ./docker /usr/local/bin", shell=True, check=True)

        # Instalar Docker Desktop si el archivo existe
        if os.path.exists(docker_path):
            subprocess.run(f"sudo pacman -U --noconfirm {docker_path}", shell=True, check=True)
            subprocess.run("systemctl --user start docker-desktop", shell=True, check=True)
            subprocess.run("systemctl --user enable docker-desktop", shell=True, check=True)
            subprocess.run(f"sudo usermod -aG docker {os.getlogin()}", shell=True, check=True)
        else:
            print(f"Advertencia: No se encontró el paquete {docker_path}, Docker Desktop no fue instalado.")

    def configure_services(self):
        print("Configurando servicios en Arch Linux...")

        machine_lang = input("¿La máquina está configurada en inglés? (Y/N): ")
        if machine_lang.strip().lower() == 'n':
            print("Por favor, descomenta la línea correspondiente a en_US.UTF-8 en /etc/locale.gen.")
            input("Presiona Enter para continuar...")
            subprocess.run(["sudo", "nano", "/etc/locale.gen"], check=True)
            subprocess.run(["sudo", "locale-gen"], check=True)

        services = ["bluethooth", 'cups.service', 'avahi-daemon']
        for service in services:
            subprocess.run(["sudo", "systemctl", "enable", service], check=True)
            subprocess.run(["sudo", "systemctl", "start", service], check=True)
        subprocess.run(['gpasswd', '-a', os.getlogin(), 'sys'], check=True)

