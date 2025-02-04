import platform
import subprocess
from distros import DistroInstallerStrategy
from distros import ArchInstaller


class Main:
    @staticmethod
    def __detect_wsl() -> bool:
        """Detecta si el sistema está corriendo en WSL."""
        try:
            with open("/proc/version", "r") as f:
                return "Microsoft" in f.read()
        except FileNotFoundError:
            return False

    @staticmethod
    def __detect_distro() -> DistroInstallerStrategy:
        """Detecta la distribución del sistema y devuelve la estrategia correspondiente."""
        try:
            with open("/etc/os-release") as f:
                data = f.read().lower()
                if "arch" in data:
                    return ArchInstaller()
                else:
                    raise ValueError("Distribución no soportada")
        except FileNotFoundError:
            raise RuntimeError("No se pudo determinar la distribución del sistema")

    @staticmethod
    def exec():
        if Main.__detect_wsl():
            print("Se detectó WSL. Algunas configuraciones pueden ser diferentes.")

        distro = Main.__detect_distro()

        print("Iniciando instalación...")
        distro.update_system()
        distro.install_packages()
        distro.configure_services()
        distro.configure_dotfiles()
        print("Instalación completada.")


if __name__ == "__main__":
    Main.exec()
