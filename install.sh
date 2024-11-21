#!/bin/bash

set -e

###########################################
# Constants and Global Variables
###########################################
readonly VALID_DISTROS="arch|ubuntu"
readonly VALID_YES_NO="Y|N|y|n"

declare REPOS_DIR=""
declare GIT_NAME=""
declare GIT_EMAIL=""
declare DISTRO=""
declare WSL=""
declare NIX=""
declare FONT_ZIP=""

###########################################
# Utility Functions
###########################################
print_colored() {
  local color=$1
  local message=$2
  case $color in
  "red") echo -e "\e[31m$message\e[0m" ;;
  "green") echo -e "\e[32m$message\e[0m" ;;
  "yellow") echo -e "\e[33m$message\e[0m" ;;
  "blue") echo -e "\e[34m$message\e[0m" ;;
  *) echo "$message" ;;
  esac
}

get_input() {
  local prompt=$1
  local valid_options=$2
  local response

  while true; do
    read -p "$prompt" response
    if [[ -z "$valid_options" || "$response" =~ ^($valid_options)$ ]]; then
      echo "$response"
      return
    fi
    print_colored "red" "Invalid input. Please try again."
  done
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

###########################################
# Installation Setup Functions
###########################################
init_script() {
  print_colored "blue" "Starting installation..."

  # Get font file path
  FONT_ZIP=$(get_input "Enter the path to the FiraCode Nerd Font ZIP file: ")
  if [[ ! -f "$FONT_ZIP" ]]; then
    print_colored "red" "File does not exist: $FONT_ZIP"
    exit 1
  fi

  # Get system configuration
  WSL=$(get_input "Are you using WSL? (Y/N): " "$VALID_YES_NO")
  DISTRO=$(get_input "Choose your distribution (arch/ubuntu): " "$VALID_DISTROS")
  REPOS_DIR=$(get_input "Enter the directory for repositories: ")

  mkdir -p "$REPOS_DIR"
}

###########################################
# Core Tool Configuration Functions
###########################################
configure_git() {
  print_colored "blue" "Configuring Git..."

  # Install Git based on distribution
  if [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -Syu --noconfirm && pacman -S --noconfirm git
  elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt-get update && sudo apt install -y git
  fi

  # Configure Git settings
  GIT_NAME=$(get_input "Enter your Git username: ")
  GIT_EMAIL=$(get_input "Enter your Git email: ")

  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global core.editor "vim"
  git config --global credential.helper store
  git config --global color.status.changed yellow
  git config --global init.defaultBranch "main"
}

###########################################
# Font Configuration Functions
###########################################
install_nerd_font() {
  local font_zip="$1"
  local font_name=$(basename "$font_zip" .zip)

  print_colored "blue" "Installing Nerd Font: $font_name"

  local font_dir="$HOME/.local/share/fonts/nerd-fonts"
  mkdir -p "$font_dir"

  cd "$font_dir"
  cp "$font_zip" .
  unzip -o "$(basename "$font_zip")"
  rm "$(basename "$font_zip")"

  fc-cache -fv

  local font_pattern="${font_name//-/ }"
  print_colored "blue" "Checking font installation for: $font_pattern"

  if fc-list | grep -i "$font_pattern" >/dev/null; then
    print_colored "green" "Font installed successfully"
    fc-match "$font_pattern" -a
  else
    print_colored "yellow" "Warning: Font might not be properly installed"
    print_colored "yellow" "Available similar fonts:"
    fc-list | grep -i "nerd" | cut -d: -f2 | sort | uniq
  fi
}

###########################################
# Development Tools Installation
###########################################
install_dev_tools() {
  print_colored "blue" "Installing development tools..."
  install_rust
  install_node
}

install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env
  rustup update
}

install_node() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 22
}

###########################################
# Main Execution
###########################################
main() {
  init_script
  install_dev_tools
  configure_git

  if [[ "$DISTRO" == "arch" ]]; then
    source ./arch.sh
    install_arch
  elif [[ "$DISTRO" == "ubuntu" ]]; then
    source ./ubuntu.sh
    install_ubuntu
  else
    print_colored "red" "Unsupported distribution. Exiting."
    exit 1
  fi

  print_colored "green" "Installation completed successfully!"
}

main
