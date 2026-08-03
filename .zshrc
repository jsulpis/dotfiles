# === Oh My Zsh ===
export ZSH="$HOME/.oh-my-zsh"


# === Zsh Plugin ===
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# === NVM ===
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh


alias ll='ls -lah'
alias l='ls -lh'


# === Git Aliases ===

# Go to project root
grt() {
 cd "$(git rev-parse --show-toplevel)"
}

# Checkout main branch and pull latest changes
# if your repo has been initialized locally (not cloned), run 'git remote set-head origin -a'
gcm() {
  git switch $(git symbolic-ref refs/remotes/origin/HEAD | cut -d/ -f4)
  git pull origin HEAD
}

alias gcl="git clone"
alias grm="git fetch && git rebase origin/HEAD"
alias grmi="git fetch && git rebase -i origin/HEAD"

alias gst="git status"
alias gps="git push origin HEAD"
alias gpsf="git push origin HEAD --force-with-lease"

alias ga="git add -A"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gs="git stash"
alias gsp="git stash pop"


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
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
eval "$(starship init zsh)"


# === pnpm ===
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"


# === bun ===
[ -s "/Users/julien/.bun/_bun" ] && source "/Users/julien/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# === Secrets ===
# security add-generic-password -s "TOKEN_NAME" -a $USER -w "secret_token_here"
export GITHUB_PAT_MCP=$(security find-generic-password -s "GITHUB_PAT_MCP" -w)
export CHANGELOGEN_TOKENS_GITHUB=$(security find-generic-password -s "GITHUB_PAT_RELEASE" -w)