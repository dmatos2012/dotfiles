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

