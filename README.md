# dotfiles

This repository contains everything I could find to automatically setup a new Mac. I also use it to synchronize my dotfiles across my devices. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy!

> **Warning**: If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. There is my name hard-coded in a few places so don’t blindly execute the script. Use at your own risk!

## Features

- Install and setup:
  - SSH
  - Homebrew
  - all my apps and a few fonts using Homebrew
  - Oh My Zsh with a few plugins and the Starship prompt
  - nvm and node LTS
  - yarn/pnpm with a few global packages
- Create symlinks for global configs (.gitconfig, .zshrc)
- Change some System Preferences (UI, Dock, Finder...)

All this with one script :)

The script will not crash if executed again (it will skip what is already installed), so it can be used to update the settings as well.

## Usage

Clone the repo (git should come pre-installed with your Mac):

```bash
git clone https://github.com/jsulpis/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
```

Review the code ! Change the name and email address.

Run the script:

```bash
./bootstrap.zsh
```

Installation is done. The script indicates the next steps to follow.

## Thanks To...

- [Dries Vints](https://driesvints.com/) for his [dotfiles](https://github.com/driesvints/dotfiles) repo and explanatory [blog post](https://driesvints.com/blog/getting-started-with-dotfiles)
- [Mathias Bynens](https://mathiasbynens.be/) for his [.macos](https://mths.be/macos) file used by literally everyone
- [Kent C. Dodds](https://kentcdodds.com/) for his [dotfiles](https://github.com/kentcdodds/dotfiles) repo
- [Anthony Fu](https://antfu.me/) for his [.zshrc](https://github.com/antfu/dotfiles/blob/main/.zshrc) file
