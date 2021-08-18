#!bin/zsh
alias s='source ~/.config/zsh/.zshrc'
# {{{1 Edit Aliases
alias ez='$EDITOR ~/.config/zsh/.zshrc'
# alias en='$EDITOR ~/Git/config_manager/vim/.nvimrc'
# }}}
# {{{1 General Aliases
alias ls='ls -F --color=auto --group-directories-first --sort=version'
alias ll='ls -al'
alias ldr='ls --color --group-directories-first'
alias h="history|grep "
alias grep="grep --color=auto"
# {{{3 Disk Aliases
# This is GOLD for finding out what is taking so much space on your drives!
alias diskspace="du -h -S | sort -n -r |more"

alias lt='ls --human-readable --size -1 -S --classify'
alias count='find . -type f | wc -l'
#alias rm="rm -vI"
#alias cp="cp -iv"
#alias mv="mv -iv"
alias cdl="cd /home/david/Downloads"
alias cdoc="cd /home/david/Documents"
alias cdesk="cd /home/david/Desktop"
alias cnvim="cd /home/david/.config/nvim"
alias cpimg="exec import png:- | xclip -selection c -t image/png"
alias svimg="scrot -s '%Y-%m-%d_$wx$h.png'"
alias xo="xdg-open"



