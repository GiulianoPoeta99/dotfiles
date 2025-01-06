sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syu --noconfirm
paru -Syu --noconfirm

sudo pacman -Scc
paru -Scc

sudo pacman -Rns $(pacman -Qdtq)
paru -Rns $(paru -Qdtq)

rm -rf ~/.cache/*

sudo rm -rf /var/log/journal/*
