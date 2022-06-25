#!/bin/sh

function printYellow() {
    echo "\n\033[33m$1\033[0m"
}
function printGreen() {
    echo "\033[32m$1\033[0m"
}
function printInstalling() {
    printYellow "\nInstalling $1..."
}
function printInstalled() {
    printGreen "$1 installed successfully\n"
}

printYellow "|\n| Hi $(whoami)! Let's get you set up.\n|"

if [ ! -f ~/.ssh/config ]; then
    printYellow "Generating SSH keys and configuration..."
    ./ssh.sh "julien.sulpis@gmail.com"
fi

# Install Rosetta which is required for the KDrive app
if [ ! -d /usr/libexec/rosetta ]; then
    printInstalling "rosetta"
    sudo softwareupdate --install-rosetta --agree-to-license
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    printInstalling "homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    printInstalled "homebrew"
fi

printYellow "Running brew update..."
brew update

printYellow "Running brew bundle..."
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Check for Oh My Zsh and install if we don't have it
if test ! $ZSH; then
    printInstalling "Oh My Zsh"
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
    printInstalled "Oh My Zsh"
fi

printInstalling "Zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null

printYellow "Creating symlinks in the home directory..."
for file in .zshrc .gitconfig 
    do ln -sF $(pwd)/$file $HOME/$file
done

printGreen "\nInstallation complete !"
echo "\nNext steps:"
echo "  - log into your web browsers and synchronize the profiles and settings"
echo "  - log into Google and GitHub"
echo "  - log into the other apps listed in the Brewfile and other online services"
echo "  - run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into your GitHub settings to import your SSH key"
