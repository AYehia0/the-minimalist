#!/bin/bash

detect_distribution() {
    if [ -f "/etc/arch-release" ]; then
        echo "arch"
    elif [ -f "/etc/debian_version" ]; then
        echo "debian"
    elif [ -f "/etc/fedora-release" ]; then
        echo "fedora"
    else
        echo "unknown"
    fi
}

install_packages() {
    distro="$1"
    dev_packages=()  # Array of development packages to be installed

    case "$distro" in
        "arch")
            dev_packages=(
                "git"
                "gcc"
                "make"
                "cmake"
                "pkgconf"
                "base-devel"
                "python"
                "python-pip"
                "ruby"
                "nodejs"
                "npm"
                "neovim"
                "tmux"
                "zsh"
                "curl"
                "wget"
                "htop"
                "tree"
                "jq"
            )
            ;;
        "debian")
            dev_packages=(
                "git"
                "gcc"
                "g++"
                "make"
                "cmake"
                "pkg-config"
                "autoconf"
                "automake"
                "libtool"
                "build-essential"
                "python3"
                "python3-pip"
                "ruby"
                "ruby-dev"
                "nodejs"
                "npm"
                "neovim"
                "tmux"
                "zsh"
                "curl"
                "wget"
                "htop"
                "tree"
                "jq"
                "httpie"
            )
            ;;
        "fedora")
            dev_packages=(
                "git"
                "gcc"
                "make"
                "cmake"
                "pkgconf"
                "autoconf"
                "automake"
                "libtool"
                "gcc-c++"
                "kernel-devel"
                "python3"
                "python3-pip"
                "ruby"
                "ruby-devel"
                "nodejs"
                "npm"
                "neovim"
                "tmux"
                "zsh"
                "curl"
                "wget"
                "htop"
                "tree"
                "jq"
                "httpie"
            )
            ;;
        *)
            echo "Unsupported distribution. Package installation aborted."
            exit 1
            ;;
    esac

    # Install development packages
    if [ ${#dev_packages[@]} -gt 0 ]; then
        package_manager=$(command -v apt || command -v dnf || command -v pacman)
        # add switch case here based on the package_manager
        case "$package_manager" in
            *apt*)
                sudo apt update
                sudo apt install "${dev_packages[@]}"
                ;;
            *dnf*)
                sudo dnf update
                sudo dnf install "${dev_packages[@]}"
                ;;
            *pacman*)
                sudo pacman -Syu
                sudo pacman -S "${dev_packages[@]}"
                ;;
            *)
                echo "Unsupported package manager. Package installation aborted."
                exit 1
                ;;
        esac
    else
        echo "No development packages to install."
    fi
}

install_oh_my_zsh() {
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_ide() {
    # copy the config files for both neovim and tmux.
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    git clone https://github.com/AYehia0/nvchad-custom ~/.config/
}

# Call the function to detect the distribution type and save it to a variable
distro_type=$(detect_distribution)

# Print the detected distribution type
echo "Installing packages for: $distro_type"
install_packages "$distro_type"

# Shell customization
echo "Installing the dotfiles"
chsh -s $(which zsh)
install_oh_my_zsh

echo "Setting up the IDE/Neovim"
setup_ide
