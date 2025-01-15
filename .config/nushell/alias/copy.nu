# Función para copiar path
def copypath [file?: string] {
    let target_file = if ($file | is-empty) { 
        $env.PWD 
    } else { 
        if ($file | str starts-with "/") { 
            $file 
        } else { 
            $"($env.PWD)/($file)" 
        }
    }
    
    # Intentamos copiar usando xclip de manera directa
    try {
        echo $target_file | ^xclip -selection clipboard
        print $"($target_file) copied to clipboard."
    } catch {
        print $"Error copying to clipboard: ($in)"
    }
}

# Función para copiar archivo
def copyfile [file: string] {
    try {
        ^xclip -selection clipboard $file
        print $"($file) copied to clipboard."
    } catch {
        print $"Error copying to clipboard: ($in)"
    }
}

# Función para copiar buffer actual
def copybuffer [] {
    try {
        echo $env.BUFFER | ^xclip -selection clipboard
        print "Buffer copied to clipboard."
    } catch {
        print $"Error copying to clipboard: ($in)"
    }
}