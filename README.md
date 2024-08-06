# Stow DotFiles

## Dependencias

### Obligatorias

- git
- stow

### Opcionales

- zsh
    - zoxide
    - eza
    - docker
    - docker compose
    - lazydocker
    - xclip
    - batcat
    - fzf
    - FiraCode Nerd Font
    - lynis

- neovim
    - lua



## Uso
Descargamos el repo en el $HOME entramos al mismo y hacemos el comando `stow <app>`

Si queres agregar algun archivo al ignore de stow hay que agrear el archivo .stow-local-ignore

### Zsh

Para instalar zsh hay que hacer lo siguiente.

```bash
cd zsh
sudo stow -t /etc etc
cd ..
stow zsh
rm ../etc
```

### Neovim

Para instalar neovim hay que hacer lo siguiente:

```bash
stow neovim
```