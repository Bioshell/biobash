#!/usr/bin/bash
export author=zhoushiyi
# exports.bash
export BINDIR=$HOME/bin
export BASHDIR="$HOME/.bash"
export PATH=$PATH:$HOME/bin/bin:$HOME/opt/bin
export MANPATH="$HOME/opt/man:/usr/local/man:$MANPATH"

# User info


## LC settings
#export LC_CTYPE=en_us.UTF-8
#export LC_ALL=en_us.UTF-8
export LC_ALL=C

#LD_LIBRARY
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HOSTFILE=$BASHDIR/.hosts    # Put a list of remote hosts in $DATADIR/.hosts

#perl environment
if [ -z "$PERL5LIB" ]
 then
         # If PERL5LIB wasn't previously defined, set it...
         PERL5LIB=$DATADIR/perl5/lib/perl5
 else
         # ...otherwise, extend it.
         PERL5LIB=$PERL5LIB:$DATADIR/perl5/lib/perl5:$BINDIR/vep
fi
export PERL5LIB=$PERL5LIB:$DATADIR/perl5/lib/perl5/site_perl
export PERL5LIB MANPATH

## R module customize location
# export R_LIBS="$DATADIR/R:$R_LIBS"
# export PATH=$BINDIR/R/bin:$PATH
# export PATH=$BINDIR/bin:$PATH
export R_PROFILE_USER=$HOME/.bash/R.profile
# python module customize location
# alias python='$BINDIR/python2.7/bin/python'
# export PATH=$BINDIR/python2.7/bin:$PATH
# PY_LIBS="$BINDIR/py_libs"
# export PYTHONPATH=$BINDIR/py_libs/lib64/python:$BINDIR/py_libs/lib/python:$PYTHONPATH
# export PATH=$BINDIR/py_libs/bin:$PATH

## Java library customize location
# export JAVA_HOME=/usr/share/jdk1.5.0_05
# export PATH=$JAVA_HOME/bin:$PATH
# export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

# User specific environment and startup programs

#---------------------------------------------------------------------

export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'export PATH=$BINDIR/cgatools-1.8.0.1/bin:$PATH
export PATH=$BINDIR/htslib/bin:$PATH
export PATH=$BINDIR/samtools-1.1-0:$PATH
export PATH=$BINDIR/p7zip_9.20.1/bin:$PATH
export PATH=$BINDIR/bin:$PATH
export DISPLAY=:0
# export PATH=/usr/lib64/openmpi/bin:$PATH
# module load mpi/openmpi-x86_64
# export PATH=/usr/lib64/mpich/bin:$PATH
# module load mpi/mpich-x86_64


