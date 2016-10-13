# aliases.bash
#### Custom area for your specific aliases, exports, functions and directives.
# alias bpfinder="$BINDIR/SVM_BP/svm_bpfinder.sh $1 $2 $3 > $1.out"
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias clean='rm -f "#"* "."*~ *~ *.bak *.dvi *.aux *.log'
alias nano='nano -w'
alias psi='ps h -eo pmem,comm | sort -nr | head'
alias debug="set -o nounset; set -o xtrace"
#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------
alias less='less -r'                          # raw control characters
alias more='less'
alias mkdir='mkdir -p'
alias vi=vim

## conda, using anaconda
alias conda_update='conda update --prefix $HOME/bin anaconda --all && clear'
alias conda_upgrade='conda upgrade --prefix $HOME/bin anaconda --all && clear'
alias conda_search='anaconda search -t conda'
alias conda_clean='conda clean --all'

## Python
alias p='python'
alias regex="regex_tester"
alias rmpyc='find . -name "*.pyc" -delete'
alias pserver='python -m SimpleHTTPServer'
alias python2='source activate python2'
alias dpython2='source deactivate python2'
#
## iPython
alias i='ipython'
alias ipynb='sudo ipython notebook --profile=dst'
#
## R
## alias R='source activate R && R'
#
