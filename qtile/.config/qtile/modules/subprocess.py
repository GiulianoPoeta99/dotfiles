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