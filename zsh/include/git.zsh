# Basic functions
alias gs='git status'
alias gpull='git pull'
alias gpush='git push'
alias gd='git diff'
alias gc='git checkout'
alias gb='git branch'
alias gl='git log --oneline'
gcount-c() {
  git rev-list --count --first-parent $1..$2
}

gcm() {
  git commit -m $1
  
}

