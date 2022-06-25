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

# Install Rosetta which is required for the KDrive app
if [ ! -d /usr/libexec/rosetta ] ; then
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

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $(pwd)/.zshrc $HOME/.zshrc

printGreen "\nInstallation complete !"