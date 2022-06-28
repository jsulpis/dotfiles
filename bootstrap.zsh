#!/bin/zsh


#################
# === Utils === #
#################

function printYellow() {
    echo "\n\033[33m$1\033[0m"
}
function printGreen() {
    echo "\033[32m$1\033[0m"
}
function printInstalling() {
    printYellow "\nInstalling $1..."
}

printYellow "|\n| Hi $(whoami)! Let's get you set up.\n|"


###############
# === SSH === #
###############

if [ ! -f ~/.ssh/config ]; then
    printYellow "Generating SSH keys and configuration..."
    ssh-keygen -t ed25519 -C 'julien.sulpis@gmail.com' -f ~/.ssh/id_ed25519
    eval "$(ssh-agent -s)"
    touch ~/.ssh/config
    echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config
    ssh-add -K ~/.ssh/id_ed25519
fi


###################
# === Rosetta === #
###################

# required for the KDrive app
if [ ! $(/usr/bin/pgrep oahd) ]; then
    printInstalling "rosetta"
    sudo softwareupdate --install-rosetta --agree-to-license
fi


####################
# === Homebrew === #
####################

if [ ! $(command -v brew) ]; then
    printInstalling "homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

printYellow "Running brew update..."
brew update

printYellow "Running brew bundle..."
brew tap homebrew/bundle
brew bundle


#####################
# === Oh My Zsh === #
#####################

if [ ! -d ~/.oh-my-zsh ]; then
    printInstalling "Oh My Zsh"
    RUNZSH='no' /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

printInstalling "Zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null

source ./.zshrc


################
# === Node === #
################

if [ ! "$(nvm ls | grep lts)" ]; then
    printInstalling "node LTS"
    nvm install --lts
fi
printInstalling "global npm packages";
pnpm i -g serve npm-check-updates @antfu/ni


####################
# === Symlinks === #
####################

printYellow "Creating symlinks in the home directory..."
for file in .zshrc .gitconfig 
    do ln -sF $(pwd)/$file $HOME/$file
done


######################
# === Origin URL === #
######################

printYellow "Changing the url of the remote origin to use SSH..."
git remote set-url origin git@github.com:jsulpis/dotfiles.git


##############################
# === System Preferences === #
##############################

printYellow "Changing system settings..."
source ./.macos


printGreen "\nInstallation complete !"
echo "\nNext steps:"
echo "  - reboot to make sure all changes are applied"
echo "  - log into the web browsers and synchronize the profiles and settings"
echo "  - log into Google and GitHub"
echo "  - log into the other apps listed in the Brewfile and other online services"
echo "  - run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into the GitHub settings to import the SSH key"
