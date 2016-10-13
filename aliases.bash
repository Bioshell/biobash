# aliases.bash
#### Custom area for your specific aliases, exports, functions and directives.

# System Utilities
alias grep='grep --color'
alias df='df -h'
alias dirf='du -d 1'
alias top='htop'
alias less='less -r'                          # raw control characters
alias more='less'
alias mkdir='mkdir -p'
alias whence='type -a'                        # where, of a sort
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias clean='rm -f "#"* "."*~ *~ *.bak *.dvi *.aux *.log'
alias nano='nano -w'
alias psi='ps h -eo pmem,comm | sort -nr | head'
alias debug="set -o nounset; set -o xtrace"
alias sudo='sudo PATH=$PATH HOME=$HOME LD_LIBRARY_PATH=$LD_LIBRARY_PATH'

# List
alias ls='ls -F'
alias la='ls -aF'
alias ll='ls -lF'
alias lsd='ls -dl */'
alias lr='ls -lR'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias back='cd $OLDPWD'

# Editors
alias vi='vim'
alias v='vim'
alias sv='sudo vim'


# conda, using anaconda
alias conda_update='conda update --prefix $HOME/bin anaconda --all && clear'
alias conda_upgrade='conda upgrade --prefix $HOME/bin anaconda --all && clear'
alias conda_search='anaconda search -t conda'
alias conda_clean='conda clean --all'

# Python
alias p='python'
alias regex="regex_tester"
alias rmpyc='find . -name "*.pyc" -delete'
alias pserver='python -m SimpleHTTPServer'
alias python2='source activate python2'
alias dpython2='source deactivate python2'
# iPython
alias i='ipython'
alias ipynb='sudo ipython notebook --profile=dst'

# R
# alias R='source activate R && R'

# Dotfiles
alias zrc='vim $HOME/.zshrc && source ~/.zshrc'
alias brc='vim $HOME/.bashrc && source ~/.bashrc'
alias vrc='vim $HOME/.vimrc && source ~/.vimrc'
