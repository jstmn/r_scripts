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
    PS1="[$FRED \w $RS] \\$ "

  # In docker image
  else
    PS1="[ $HOSTNAME: $FBLE\w $RS] \\$ "
fi


# assorted
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias cl='clear'
alias sourcebashrc='source ~/.bashrc'
alias sourcevenv='source venv/bin/activate'
alias urdfviz='/home/jstm/Libraries/urdf-viz'
alias mkvenv='python3.8 -m venv'

# git short cuts
alias gb='git branch'
alias gs='git status'
alias pushreadmechange='git add README.md && git commit -m "updated readme" && git push origin HEAD'


# Quick starts
alias ikflow_quickstart='cd ~/Projects/ikflow; source venv/bin/activate'
alias jkinpylib_quickstart='cd ~/Projects/jkinpylib; source venv/bin/activate'
alias cppflow_quickstart='cd ~/Projects/cppflow; source venv/bin/activate'


# ssh shortcuts
alias sshbrain='ssh jeremysmorgan@X'
