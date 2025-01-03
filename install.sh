#!/bin/bash

set -e

###########################################
# CONSTANTS AND GLOBAL VARIABLES
###########################################
readonly VALID_DISTROS="arch|ubuntu"
readonly VALID_YES_NO="Y|N|y|n"
readonly WORKING_DIR="$(pwd)"

declare REPOS_DIR=""
declare GIT_NAME=""
declare GIT_EMAIL=""
declare DISTRO=""
declare WSL=""
declare NIX=""
declare FONT_ZIP=""

###########################################
# UTILITY FUNCTIONS
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
# INSTALLATION SETUP FUNCTIONS
###########################################
init_script() {
  print_colored "blue" "Starting installation..."

  # Get font file path
  FONT_ZIP=$(get_input "Enter the path to the Nerd Font ZIP file: ")
  if [[ ! -f "$FONT_ZIP" ]]; then
    print_colored "red" "File does not exist: $FONT_ZIP"
    exit 1
  fi

  # Get system configuration
  WSL=$(get_input "Are you using WSL? (Y/N): " "$VALID_YES_NO")
  DISTRO=$(get_input "Choose your distribution (arch/ubuntu/fedora/suse): " "$VALID_DISTROS")
  REPOS_DIR=$(get_input "Enter the directory for repositories: ")

  mkdir -p "$REPOS_DIR"
}

###########################################
# Main Execution
###########################################
main() {
  init_script

  if [[ "$DISTRO" == "arch" ]]; then
    source ./scripts/arch.sh
    main_arch
  elif [[ "$DISTRO" == "ubuntu" ]]; then
    source ./scripts/ubuntu.sh
    main_ubuntu
  elif [[ "$DISTRO" == "fedora" ]]; then
    source ./scripts/fedora.sh
    main_ubuntu
  elif [[ "$DISTRO" == "suse" ]]; then
    source ./scripts/suse.sh
    main_ubuntu
  else
    print_colored "red" "Unsupported distribution. Exiting."
    exit 1
  fi

  print_colored "green" "Installation completed successfully!"
}

main
