# Basic functions
alias gs='git status'
alias gpull='git pull'
alias gpush='git push'
alias gd='git diff'
alias gc='git checkout'
alias gb='git branch'
alias gl='git log --oneline'
gcount-c() {
  # List # of commits since a branch was created
  git rev-list --count --first-parent $1..$2
}

gcm() {
  git commit -m $1
  
}

gc-by-date() {
    # If less than 90 days, use this
    #git checkout 'master@{1979-02-26 18:30:00}'

    # If more than 90 days, use below
    git checkout `git rev-list -n 1 --first-parent --before=$1 master`

}

