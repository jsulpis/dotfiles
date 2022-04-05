# === Install Oh My Zsh ===
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH="$HOME/.oh-my-zsh"


# === Install plugins ===
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# === Load nvm ===
# brew install nvm 
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh


# === Git Aliases ===
alias gcl="git clone"
alias grt='cd "$(git rev-parse --show-toplevel)"' # Go to project root
alias gcm="git checkout main && git pull"
alias grm="gcm && git checkout - && git rebase main"

alias gst="git status"
alias gps="git push origin HEAD"
alias gpsf="git push origin HEAD --force-with-lease" # After rebase :) 
alias gpl="git pull"

alias ga="git add -A"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gs="git stash"
alias gsp="git stash pop"

alias gl="git lg --all"
alias grb="git rebase"
alias gco="git checkout"


# === Utilities ===
killport() {
    pid=$(lsof -n -i:$1 | grep LISTEN | awk '{ print $2 }' | uniq)
    
    if [ ! -z "$pid" ] 
    then 
        kill -TERM $pid || kill -KILL $pid;
        echo "Successfully killed process $pid listening on port $1.";
    else 
        echo "No process listening on port $1.";
    fi
    
}

# === Install the starship prompt ===
# brew install starship

export STARSHIP_CONFIG=~/dotfiles/starship.toml

eval "$(starship init zsh)"