# Stow DotFiles

## Dependencias

- stow

## Uso
Descargamos el repo en el $HOME entramos al mismo y hacemos el comando `stow <app>`

Si queres agregar algun archivo al ignore de stow hay que agrear el archivo .stow-local-ignore

### Zsh

Para instalar zsh hay que hacer lo siguiente.

```bash
sudo stow -t / zsh/etc
stow zsh
```


### Neovim

Para instalar neovim hay que hacer lo siguiente:

```bash
stow neovim
```