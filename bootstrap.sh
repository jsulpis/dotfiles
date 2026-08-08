#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(pwd)"
OS="$(uname -s)"

#################
# === Utils === #
#################

printYellow() {
    printf '\n\033[33m%b\033[0m\n' "$1"
}

printGreen() {
    printf '\033[32m%b\033[0m\n' "$1"
}

printInstalling() {
    printYellow "Installing $1..."
}

printYellow "|\n| Hi $(whoami)! Let's get you set up.\n|"


if [ "$OS" = "Linux" ]; then
    printInstalling "OS libs"
    sudo apt update && sudo apt install -y unzip xclip
fi


###############
# === SSH === #
###############

ssh_dir="$HOME/.ssh"
key="$ssh_dir/id_ed25519"
mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"

if [ ! -f "$key" ]; then
    printYellow "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$key"
    chmod 600 "$key" 2>/dev/null || true
    chmod 644 "$key.pub" 2>/dev/null || true
fi

ssh_config="$ssh_dir/config"
touch "$ssh_config"
chmod 600 "$ssh_config"
if ! grep -q '^Host \*$' "$ssh_config"; then
    printYellow "Generating SSH config..."
    {
        printf '\nHost *\n'
        printf '  AddKeysToAgent yes\n'
        printf "  IdentityFile $key\n"
        if [ "$OS" = "Darwin" ]; then
            printf '  UseKeychain yes\n'
        fi
    } >> "$ssh_config"
fi

eval "$(ssh-agent -s)" >/dev/null
if [ "$OS" = "Darwin" ]; then
    ssh-add --apple-use-keychain "$key" 2>/dev/null || true
else
    ssh-add "$key" 2>/dev/null || true
fi


###############
# === ZSH === #
###############

if [ "$OS" = "Linux" ]; then
    printInstalling "Zsh"
    sudo apt install -y zsh
    chsh -s $(which zsh)
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    printInstalling "Oh My Zsh"
    RUNZSH='no' CHSH='no' /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$zsh_custom/plugins"
[ -d "$zsh_custom/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
[ -d "$zsh_custom/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"


####################
# === Homebrew === #
####################

if ! command -v brew >/dev/null 2>&1; then
    printInstalling "homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


    if [ "$OS" = "Darwin" ]; then
        BREW_PREFIX="/opt/homebrew"
        echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" >> "$HOME/.zprofile"
    else
        BREW_PREFIX="/home/linuxbrew/.linuxbrew"
        (echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\""; cat ".zshrc") > temp && mv temp ".zshrc"
    fi
    eval "$("$BREW_PREFIX/bin/brew" shellenv)"
fi

printYellow "Running brew update..."
brew update

printYellow "Running brew bundle..."
brew trust --formula anomalyco/tap/opencode
brew bundle


##################
# === Docker === #
##################

if [ "$OS" = "Linux" ]; then
    printInstalling "docker"
    # Add Docker's official GPG key:
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings

    DISTRO=$(. /etc/os-release && echo "$ID")

    if [[ "$DISTRO" =~ ^(ubuntu|raspbian)$ ]]; then
        sudo curl -fsSL "https://download.docker.com/linux/${DISTRO}/gpg" -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${DISTRO} ${CODENAME} stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    sudo apt update

    ## Install the Docker packages
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    ## Add current user to the docker group
    sudo usermod -aG docker $USER
fi


################
# === Node === #
################

export NVM_DIR="$HOME/.nvm"
NVM_PREFIX="${HOMEBREW_PREFIX}/opt/nvm"

if [ -s "$NVM_PREFIX/nvm.sh" ]; then
    source "$NVM_PREFIX/nvm.sh"
    if ! nvm version "lts/*" >/dev/null 2>&1; then
        printInstalling "node LTS"
        nvm install --lts
    fi
fi


if ! grep -q "PNPM_HOME" ~/.zshrc 2>/dev/null; then
    if [ "$OS" = "Darwin" ]; then
        export PNPM_HOME="$HOME/Library/pnpm"
    else
        export PNPM_HOME="$HOME/.local/share/pnpm"
    fi
    case ":$PATH:" in
      *":$PNPM_HOME/bin:"*) ;;
      *) export PATH="$PNPM_HOME/bin:$PATH" ;;
    esac
    pnpm setup
fi
printInstalling "global npm packages"
pnpm i -g @antfu/ni


####################
# === Symlinks === #
####################

printYellow "Creating symlinks in the home directory..."
for file in .zshrc .gitconfig; do
    ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
done

printYellow "Creating symlinks for VS Code settings..."
if [ "$OS" = "Darwin" ]; then
    vscode_dir="$HOME/Library/Application Support/Code/User"
else
    vscode_dir="$HOME/.config/Code/User"
fi

mkdir -p "$vscode_dir"
for item in "$DOTFILES_DIR/.vscode/"*; do
    [ -e "$item" ] || continue
    file=$(basename "$item")
    ln -sfn "$item" "$vscode_dir/$file"
done


######################
# === Origin URL === #
######################

printYellow "Changing the url of the remote origin to use SSH..."
git remote set-url origin git@github.com:jsulpis/dotfiles.git


##############################
# === System Preferences === #
##############################

if [ "$OS" = "Darwin" ] && [ -f "$DOTFILES_DIR/.macos" ]; then
    printYellow "Changing system settings..."
    # shellcheck disable=SC1091
    bash "$DOTFILES_DIR/.macos"
fi

printGreen "\nInstallation complete !"
printf '%s\n' "Next steps:"
printf '%s\n' "  - reboot to make sure all changes are applied"
printf '%s\n' "  - log into the web browsers and synchronize the profiles and settings"
printf '%s\n' "  - log into Google and GitHub"
printf '%s\n' "  - log into the other apps listed in the Brewfile and other online services"
if [ "$OS" = "Darwin" ]; then
    printf '%s\n' "  - run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into the GitHub settings to import the SSH key"
else
    printf '%s\n' "  - run 'xclip -selection clipboard < ~/.ssh/id_ed25519.pub' (if xclip is installed) and paste that into GitHub"
fi
