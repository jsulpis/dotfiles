# === Install Oh My Zsh ===
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH="$HOME/.oh-my-zsh"


# === Install the Spaceship prompt ===
# git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
ZSH_THEME="spaceship"


# === Keep only the features I want, otherwise it's too slow ===
# (reference : https://spaceship-prompt.sh/options)
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  char          # Prompt character
)
SPACESHIP_GIT_STATUS_SHOW=false


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

alias gst="git status"
alias gp="git push origin HEAD"
alias gpf="git push origin HEAD --force-with-lease"
alias gpl="git pull"

alias ga="git add -A"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gs="git stash"
alias gsp="git stash pop"

alias gl="git lg --all"
alias grb="git rebase"
alias gco="git checkout"
