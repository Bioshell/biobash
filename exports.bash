# exports.bash

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HOSTFILE=$BASHDIR/.hosts    # Put a list of remote hosts in $DATADIR/.hosts
#export LC_CTYPE=en_us.UTF-8
#export LC_ALL=en_us.UTF-8
export MANPATH="$HOME/opt/man:/usr/local/man:$MANPATH"
#LD_LIBRARY
# function gfortran()
#	{
#	export LD_LIBRARY_PATH=$BINDIR/lib:$BINDIR/lib64:$BINDIR/lib64/gmp-6.0.0/include:$BINDIR/lib64/gmp-6.0.0/lib:$LD_LIBRARY_PATH
#	/usr/local/gcc-4.8/bin/gfortran "$@"
#	}
export LD_LIBRARY_PATH=$BINDIR/lib:$BINDIR/lib64:$BINDIR/lib64/mpfr-3.1.2:$BINDIR/lib64/gmp-6.0.0:$BINDIR/lib64/mpc-1.0.2:/opt/SRC/gcc-4.8.2/build/x86_64-redhat-linux/32/libquadmath/.libs:/opt/SRC/gcc-4.8.2/build/x86_64-redhat-linux/32/libquadmath/.libs:/opt/SRC/gcc-4.8.2/build/x86_64-redhat-linux/libquadmath/.libs:/opt/SRC/gcc-4.8.2/build/x86_64-redhat-linux/libquadmath/.libs:$LD_LIBRARY_PATH

#perl environment

if [ -z "$PERL5LIB" ]
 then
         # If PERL5LIB wasn't previously defined, set it...
         PERL5LIB=$DATADIR/perl5/lib/perl5

 else
         # ...otherwise, extend it.
         PERL5LIB=$PERL5LIB:$DATADIR/perl5/lib/perl5:$BINDIR/vep
         

fi

MANPATH=$MANPATH:$DATADIR/perl5/man
export PERL5LIB=$PERL5LIB:$DATADIR/perl5/lib/perl5/site_perl
export PERL5LIB MANPATH

# R module customize location
export R_LIBS="$DATADIR/R:$R_LIBS"
#export PATH=$BINDIR/R/bin:$PATH
#export PATH=$BINDIR/bin:$PATH

# python module customize location
# alias python='$BINDIR/python2.7/bin/python'
# export PATH=$BINDIR/python2.7/bin:$PATH
PY_LIBS="$BINDIR/py_libs"
export PYTHONPATH=$BINDIR/py_libs/lib64/python:$BINDIR/py_libs/lib/python:$PYTHONPATH
export PATH=$BINDIR/py_libs/bin:$PATH

#Java library customize location
CLASSPATH=$DATADIR/jre-7u51-linux-i586/lib
PATH=$DATADIR/jre-7u51-linux-i586/bin:$PATH
export CLASSPATH PATH

# User specific environment and startup programs
export PATH=$DATADIR/perl5/bin:$PATH
export PATH=$DATADIR/lib/libgd-2.1.0/bin:$PATH
export PATH=$BINDIR:$BINDIR/vcftools_0.1.12b:$PATH
export PATH=$BINDIR/bedtools-2.21.0:$PATH
export PATH=$BINDIR/annovar:$PATH
export PATH=$BINDIR/bwa-0.7.11:$PATH
export PATH=$BINDIR/picard-tools-1.115:$PATH
export PATH=$BINDIR/bowtie2-2.2.3:$PATH
export PATH=$BINDIR/NGSQCToolkit_v2.3.3/Format-converter:$BINDIR/NGSQCToolkit_v2.3.3/QC:$BINDIR/NGSQCToolkit_v2.3.3/Statistics:$BINDIR/NGSQCToolkit_v2.3.3/Trimming:$PATH
export PATH=$BINDIR/fastqc_v0.11.2:$PATH
export PATH=$BINDIR/snpEff-3.6:$PATH
export PATH=$BINDIR/bfast-0.7.0a/bin:$PATH
export PATH=$BINDIR/vep:$PATH
export PATH=$BINDIR/blat:$PATH
export PATH=$PATH:.
export PATH=$BINDIR/InterProScan_5:$BINDIR/InterProScan_5/bin/blast/2.2.19:$BINDIR/InterProScan_5/bin/blast/2.2.6:$BINDIR/InterProScan_5/bin/coils:$BINDIR/InterProScan_5/bin/gene3d:$BINDIR/InterProScan_5/bin/hmmer2/2.3.2:$BINDIR/InterProScan_5/bin/hmmer3/3.0b2:$BINDIR/InterProScan_5/bin/hmmer3/3.1b1:$BINDIR/InterProScan_5/bin/nucleotide:$BINDIR/InterProScan_5/bin/panther/7.0:$BINDIR/InterProScan_5/bin/phobius/1.01:$BINDIR/InterProScan_5/bin/pirsf/2.85:$BINDIR/InterProScan_5/bin/prints:$BINDIR/InterProScan_5/bin/prodom/2006.1:$BINDIR/InterProScan_5/bin/prosite:$BINDIR/InterProScan_5/bin/signalp/4.0:$BINDIR/InterProScan_5/bin/superfamily/1.75:$BINDIR/InterProScan_5/bin/tmhmm/2.0:$PATH
export PATH=$BINDIR/meme/bin:$PATH
export PATH=$BINDIR/bin:$PATH
# export PATH=$BINDIR/perl-5.10.1/bin:$PATH
export PATH=$BINDIR/ImageMagick-6.8.9-8/bin:$PATH
export PATH=$BINDIR/consed:$PATH
export PATH=$BINDIR/consed/bin:$PATH
export PATH=$DATADIR/scripts:$PATH
export PATH=$BINDIR/plinkseq-0.10:$PATH

#-------------------------------------------------------------------

export snpEff=$BINDIR/snpEff-3.6/snpEff.jar
export SnpSift=$BINDIR/snpEff-3.6/SnpSift.jar
export PICARD=$BINDIR/picard-tools-1.115
export WORKLINE=$DATADIR/data/workline
export ENSEMBL="$DATADIR/data/database/Ensembl/vep"
export GATK=$BINDIR/GATK-3.3-0/GenomeAnalysisTK.jar
export LOG=$DATADIR/data/workline/log
export DATABASE=$DATADIR/data/database
export PROJECT=$DATADIR/data/project
export TRINITY=$BINDIR/trinity
export CONSED_HOME=$BINDIR/consedexport PATH=$BINDIR/ClinSeK_v1.0:$PATH
export muTect=$BINDIR/muTect-1.1.5/muTect-1.1.5.jar
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
export LC_ALL=C
export DISPLAY=:0
# export PATH=/usr/lib64/openmpi/bin:$PATH
# module load mpi/openmpi-x86_64
# export PATH=/usr/lib64/mpich/bin:$PATH
# module load mpi/mpich-x86_64
export PATH=/usr/local/Zotero_linux-x86_64:$PATH
LC_CTYPE=en_US.UTF8

# ImageMagick
export MAGICK_HOME="$HOME/bin/ImageMagick-7.0.1"
export PATH="$MAGICK_HOME/bin:$PATH"
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
