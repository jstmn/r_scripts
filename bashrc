
# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

if [ ${#HOSTNAME} -gt 20 ]
  
  # On host machine
  then
    PS1="[$FBLE \w $RS] \\$ "

  # In docker image
  else
    PS1="[ $HOSTNAME: $FBLE\w $RS] \\$ "    
fi

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias gb='git branch'
alias gs='git status'
alias cl='clear'

alias nnik_quickstart='cd ~/Projects/nn_ik; source venv/bin/activate'
alias ikflow_quickstart='cd ~/Projects/ikflow; source venv/bin/activate'
alias jkinpylib_quickstart='cd ~/Projects/Jkinpylib; source venv/bin/activate'
