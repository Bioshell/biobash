# aliases.bash
#### Custom area for your specific aliases, exports, functions and directives.
alias bpfinder="$BINDIR/SVM_BP/svm_bpfinder.sh $1 $2 $3 > $1.out"
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
