# === Oh My Zsh ===
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH="$HOME/.oh-my-zsh"


# === Zsh Plugin ===
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# === NVM ===
# brew install nvm 
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh


# === Git Aliases ===
alias gcl="git clone"
alias grt='cd "$(git rev-parse --show-toplevel)"' # Go to project root

# if your repo has been initialized locally (not cloned), run 'git remote set-head origin -a'
alias gcm="git switch $(git symbolic-ref refs/remotes/origin/HEAD | cut -d/ -f4) && git pull origin HEAD"
alias grm="git fetch && git rebase origin/HEAD"

alias gst="git status"
alias gps="git push origin HEAD"
alias gpsf="git push origin HEAD --force-with-lease" # After rebase :) 
alias gpl="git pull origin HEAD"

alias ga="git add -A"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gs="git stash"
alias gsp="git stash pop"

alias gl="git lg --all" # git alias defined in .gitconfig


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


# === Starship prompt ===
# brew install starship
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
eval "$(starship init zsh)"


# === pnpm ===
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"


# === bun ===
[ -s "/Users/julien/.bun/_bun" ] && source "/Users/julien/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
