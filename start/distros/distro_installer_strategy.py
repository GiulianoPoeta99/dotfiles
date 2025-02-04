from abc import ABC, abstractmethod
import os
import subprocess


class DistroInstallerStrategy(ABC):
    @abstractmethod
    def update_system(self):
        pass

    @abstractmethod
    def install_packages(self):
        pass

    @abstractmethod
    def configure_services(self):
        pass

    def configure_dotfiles(self):
        print("Configurando dotfiles...")

        git_name = input("Ingrese su nombre para la configuración de Git: ")
        git_email = input("Ingrese su correo para la configuración de Git: ")

        subprocess.run(["git", "config", "--global", "user.name", git_name], check=True)
        subprocess.run(["git", "config", "--global", "user.email", git_email], check=True)
        subprocess.run(["git", "config", "--global", "core.editor", "vim"], check=True)
        subprocess.run(["git", "config", "--global", "credential.helper", "store"], check=True)
        subprocess.run(["git", "config", "--global", "color.status.changed", "yellow"], check=True)
        subprocess.run(["git", "config", "--global", "init.defaultBranch", "main"], check=True)

        dotfiles_dir = os.path.expanduser("~/.repositories/dotfiles")
        zsh_state_dir = os.path.expanduser("~/.local/state/zsh")
        zsh_history_file = os.path.join(zsh_state_dir, "history")

        os.chdir(dotfiles_dir)
        print(f"Entrando en {dotfiles_dir}")

        subprocess.run(["sudo", "rm", "-f", "/etc/zsh/zshenv"], check=True)
        
        shell_dir = os.path.join(dotfiles_dir, "shell")
        os.chdir(shell_dir)
        subprocess.run(["sudo", "stow", "-t", "/etc", "etc"], check=True)

        os.chdir(dotfiles_dir)
        subprocess.run(["stow", "shell"], check=True)

        os.makedirs(zsh_state_dir, exist_ok=True)
        open(zsh_history_file, 'a').close()

        subprocess.run(["chsh", "-s", subprocess.run(["which", "zsh"], capture_output=True, text=True).stdout.strip()], check=True)

        subprocess.run(["atuin", "import", "auto"], check=True)
