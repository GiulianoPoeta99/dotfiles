import subprocess

def count_screens() -> int:
    try:
        result = subprocess.check_output("xrandr --listmonitors", shell=True).decode()
        lines = result.split('\n')
        if len(lines) > 1:
            num_screens = int(lines[0].split(':')[1].strip())
            return num_screens
        else:
            return 0
    except Exception as e:
        print(f"Error al contar las pantallas: {e}")
        return 0
    
def get_distro_icon() -> str:
    distro_icon = {
        'undefined': '',
        'md': '󰌽',
        'kali': '',
        'rocky': '',
        'mint': '󰣭',
        'alma': '',
        'alpine': '',
        'aosc': '',
        'macos': '',
        'archcraft': '',
        'archlabs': '',
        'arch': '',
        'arco': '',
        'arduino': '',
        'artix': '',
        'biglinux': '',
        'centos': '',
        'codeberg': '',
        'crystal': '',
        'debian': '',
        'devuan': '',
        'elemetary': '',
        'endevour': '',
        'fedora': '',
        'freebsd': '',
        'garuda': '',
        'gentoo': '',
        'mageia': '',
        'madriva': '',
        'manjaro': '',
        'mx': '',
        'nix': '',
        'opensuse': '',
        'parrot': '',
        'puppy': '',
        'qubeos': '',
        'redhat': '',
        'slackware': '',
        'solus': '',
        'tails': '',
        'ubuntu': '',
        'vanilla': '',
        'void': '',
        'zorin': '',
        'popos': '',
        'raspberry': ''
    }
    
    return distro_icon['ubuntu']