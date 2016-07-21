#!/usr/bin/bash
# functions.sh
# NGS data analysis scripts
# Author: Zhou Shiyi email: shiyiz@labmates.cn
lastmodified="26 Feb 2015"
#######################################
# 8 Aug 2014 
#######################################
## File functions 
 CFG_SET(){
   if [ -n "$1" ]; then
	source $1
	else
	echo -e "Dear User, you did not provide any config files...  \n \
	Now, I am searching current directory... \n"
	CFGN=$(ls *.cfg | wc -l)
        case "${CFGN}" in
          0)
	  echo -e "I am sorry, there is no config file.. \n "
	  read -t 60 -p "Do you want to provide config file now? (y/n)" ANSWER
	  case "${ANSWER}" in
		Y | y) 
		read -t 60 -p "Please provide your config file here: " CFG
		if [ -r $CFG ] && [ "${CFG}" != "" ]; then
			source ${CFG}
			else 
			echo "Sorry, the config file does not exist, or cannot read, see you next time..."
			exit
		fi
		source ${CFG}
		 ;;
		N | n)
		echo "I am exiting now.."
		exit
		 ;;
		*)
		echo "Sorry, I don't know your commend, I am exiting now.."
		exit
		 ;;
	  esac
          ;;
          1)
          source ./*.cfg
          ;;
          *)
          echo -e "There are ${CFGN} configure files exist in your working directory.. \n"
          echo -e "Including: \n"
          ls ./*.cfg
          read -p "Please choose one from the list: " CFG
          if [ -r $CFG ] && [ "${CFG}" != "" ]; then
            source ${CFG}
          else
            echo "Sorry, the cofig file setting failed, I am exiting now.."
            exit
          fi
          ;;
      esac
   fi
 }
 B_SUB(){
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo -e "Usage: \n \t $FUNCNAME \"<commands>|<scripts>\" \n Example: B_SUB \"ANNOVAR test.vcf\""
   else
    Task=$1
    EMAIL=paezs@nus.edu.sg
    DATE=`date "+%m_%d_%H_%M"`
    QUEUE=`bqueues atlas5_parallel atlas7_parallel atlas5_large atlas7_large | sort -k8n,8 | sed -n 2p | awk '{print $1}'`
    bsub -q $QUEUE -u $EMAIL -o $LOG/${DATE}.${Task}.log $*

  # Unset $var used in function----------------------------------
  fi
  unset DATE Task QUEUE EMAIL 
 }
 extract(){
  if [ -z "$1" ]; then
    # display usage if no parameters given
     echo "Usage: $FUNCNAME <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
      if [ -f $1 ] ; then
          case $1 in
              *.tar.bz2)   tar xjf $1        ;;
              *.tar.gz)    tar xzf $1     ;;
              *.bz2)       bunzip2 $1       ;;
              *.rar)       rar x $1     ;;
              *.gz)        gunzip $1     ;;
              *.tar)       tar xf $1        ;;
              *.tbz2)      tar xjf $1      ;;
              *.tgz)       tar xzf $1       ;;
              *.zip)       unzip $1     ;;
              *.Z)         gzip -d $1  ;;
              *.7z)        7z x $1    ;;
              *.tar.xz)    tar xvfJ $1    ;;
              *.rar)       unrar x $1     ;;
              *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
      else
          echo "'$1' is not a valid file"
      fi
  fi
 }
 bextract(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz> \nExample:\t$FUNCNAME gz"
   else
     ls *.$1 > /tmp/${FUNCNAME}.txt
     while read infile; do
	echo -e "Now, extracting $infile...\n"
	infile=$(find `pwd` -type f -name $infile)
	extract ${infile}
     done</tmp/${FUNCNAME}.txt
     rm -rf /tmp/${FUNCNAME}.txt
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 EMPTYF(){
  if [ -z "$1" ]; then
    # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <path/> \n \t $FUNCNAME <path/> <mindepth> <maxdepth>"
   else
   if [ "$2" = "" ] && [ "$3" = "" ]; then
      find $1 -type f -empty -print0 | xargs -0 -I {} /bin/rm "{}"
     elif [ "$2" != "" ] && [ "$3" != "" ]; then
      find $1 -mindepth $2 -maxdepth $3 -type f -empty -print0 | xargs -0 -I {} /bin/rm "{}"	
     elif [ "$2" = "" ] || [ "$3" = "" ]; then
     echo -e "Usage: \n \t EMPTYE <path/> <mindepth> <maxdepth>"
   fi	
  fi
 }
 EMPTYD(){
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t $FUNCNAME <path/> \n \t $FUNCNAME <path/> <mindepth> <maxdepth>"
     else
   if [ "$2" = "" ] && [ "$3" = "" ]; then
      find $1 -type d -empty -print0 | xargs -0 -I {} /bin/rmdir "{}"
     elif [ "$2" != "" ] && [ "$3" != "" ]; then
      find $1 -type d -mindepth $2 -maxdepth $3 -empty -print0 | xargs -0 -I {} /bin/rmdir "{}"	
     elif [ "$2" = "" ] || [ "$3" = "" ]; then
     echo -e "Usage: \n \t EMPTYE <path/> <mindepth> <maxdepth>"
   fi	
  fi
 }
 mktar(){ 
  tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; 
 }
 mkzip(){ 
  zip -r "${1%%/}.zip" "$1" ; 
 }
 sanitize(){
  chmod -R u=rwX,g=rX,o= "$@" ;
 }
 splitline(){
   # split lines in pipe after n char (default=60)
   # usage command | command | splitline 70
   # the  char is used to temporarily convert tabs to 1-char length
   # tabs are restored at the end
   lim=${1:-60}
   tr "\t" "" | sed -e "s/.\{${lim}\}/&\n/g" | tr "" "\t"
 }
 SPLIT(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <INFILE> <lines per file> \nExample:\t$FUNCNAME <Infile> <default=10000>"
   else
  INFILE $1
  total_lines=$(wc -l <$Infile)
  if [ -z "$2" ]; then
     lines_per_file=100000
     else
     lines_per_file=$2
  fi
  split --lines=${lines_per_file:=100000} --additional-suffix=\.${InfileE} ${Infile} ${InfileN}.
  echo "Total Lines = ${total_lines}"
  echo "Lines per file = ${lines_per_file}"
  fi
  unset Infile InfileE InfileN lines_per_file total_lines
  }
 INFILE(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <INFILE> \nExample:\t$FUNCNAME <.bashrc>"
   else
   Infile=$1
     if [ "$(dirname $Infile)" = "." ]; then
	 Infile=$(basename $Infile)
         Infile=$(find `pwd` -type f -name $Infile)	
     fi
   Infolder=$(dirname ${Infile})
   InfileN=$(basename ${Infile}); InfileN=${InfileN%.*}
   InfileE=${Infile##*.}     
   # Unset $var used in function----------------------------------
   fi
 }
 DIR_test(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t DIR_test <path/>"
	else
	DIR=$1
	if [ -d $DIR ] && [ -w $DIR ] && [ -n "$DIR" ]; then
	  echo "Your working directory is: $DIR"
	  else
	  until [ -d $DIR ] && [ -w $DIR ] && [ -n "$DIR" ]
	    do
	    echo "The working directory is not a valid folder or not writeable."
	    if read -t 60 -p "Please redefine your working directory (No variable!): " DIR; 
	       then
	       echo "Your working directory is $DIR, testing now.."
	       else
	       echo "Sorry, it's too slow.., I am exiting now.."
	       exit
	    fi
	  done
	fi
	DIR=$(echo $DIR)
	echo "Your working directory is: $DIR"
  fi
 }
### File functions end...
## Sequence data Quality testing..
### Sequence data Quality end ...
## Mapping tools
 BWA_INDEX(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t BWA_INDEX <path/>"
     else
      INFILE $1
       if [ "$2" = "" ]; then
	   Outfolder=${Infolder}
	  else
	   Outfolder=$2
       fi
      Outfolder=${Outfolder%/}
      mkdir -p ${Outfolder}/output
      Outfolder=${Outfolder}/output

   bwa index -a ${BIA:=is} ${Infile} -p ${BIP:=${InfileN}}
  # --------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 BWA(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t BWA_ALIGN <path/>"
     else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   mkdir -p ${Outfolder}/output
   Outfolder=${Outfolder}/output
   bwa mem # default: Using bwa-mem algorithms, which is the latest, and faster and more accurate;
	# bwa aln/samse/sampe for BWA-backtrack; 
	# bwa bwasw for BWA-SW
	# bwa mem for BWA-MEM
  #---------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 # BOWTIE2 functions...
 BOWTIE2(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t $FUNCNAME <genome build> <p/s> <left/right/Single> <right/left/-> <mode> \n\t Genome build: hg18, hg19, MM9\n\t p/s: p: paired reads; s: unpaired reads\n\t mode: \n\t\t 11: --end-to-end, --very-fast\n\t\t 12: --end-to-end, --fast\n\t\t 13: --end-to-end,--sensitive (defualt)\n\t\t 14: --end-to-end,--very-sensitive\n\t\t 21: --local,--very-fast-local\n\t\t 22: --local,--fast-local\n\t\t 23: --local,--sensitive-local\n\t\t 24: --local,--very-sensitive-local\n\t\t 00: custom setting (you can define it in cfg file or add it after \"mode\")\nExample:\t$FUNCNAME hg19 p m1.txt m2.txt 13\n\t\t$FUNCNAME hg19 s U.txt 13\n\t\t$FUNCNAME hg19 s U.txt 00 \"-D 15 -R 2 -L 22 -i S,1,1.15\""
   else
    case "$1" in
        HG18 | hg18)
	 reference=$DATABASE/UCSC/homo/hg18.fasta
	 ;;
	hg19 | HG19 | GRC37)
         reference=$DATABASE/UCSC/homo/hg19.fasta
	 ;;
	MM9 | mm9)
	 reference=$DATABASE/UCSC/mus/Mus_musculus_assembly9.fasta
	 ;;
      # Name | Alias)
      #  reference=path/to/your/genome
      #  ;;
	*)
	 echo -e "There is no genome build info provided, you can manually add your genome info to \"$DATADIR/scripts/lib/functions.sh\" \n Name \| Alias\)\n reference=path/to/your/genome\n \;\;"
	 ;;
    esac
      BOWTIE2_INDEXES=${reference}
      if [ -r ${reference}.1.bt2 ] && [ -r ${reference}.2.bt2 ] && [ -r ${reference}.3.bt2 ] && [ -r ${reference}.4.bt2 ] && [ -r ${reference}.rev.1.bt2 ] && [ -r ${reference}.rev.2.bt2 ]; then
	echo 
	else
         bowtie2-build ${reference} ${reference}
      fi
    MODE()
        {
	   case "$5" in
		11)
		 mode="--very-fast"
		 ;;
		12)
		 mode="--fast"
		 ;;
		13)
		 mode="--sensitive"
		 ;;
		14)
		 mode="--very-sensitive"
		 ;;
		21)
		 mode="--very-fast-local"
		 ;;
		22)
		 mode="--fast-local"
		 ;;
		23)
		 mode="--sensitive-local"
		 ;;
		24)
		 mode="--very-sensitive-local"
		 ;;
		00)
		 mode=${custom}
		 ;;
		*)
		 ;;
	   esac
        }
    case "$2" in
	p | P | pair )
	 for Left in `cat ${3}`; do
	    find `pwd` -mindepth ${mindepth:=1} -maxdepth ${maxdepth:=2} -type f -name ${Left} >> left.txt
	 done
	 left=$(awk '{{printf"%s,",$0}}' left.txt)
	 for Right in `cat ${4}`; do
	    find `pwd` -mindepth ${mindepth:=1} -maxdepth ${maxdepth:=2} -type f -name ${Right} >> right.txt
	 done
	 right=$(awk '{{printf"%s,",$0}}' right.txt)
	 if [ "${5}" = "00" ]; then
		mode=${6}
		else
		MODE ${5}
	 fi
           ## bowtie2 tags...
	 bowtie2 --rg-id ${FAMID} --rg "PL:${Platform}" --rg "SM:$(basename ${fsampleN})" ${mode} -x ${reference} -1 ${left} -2 ${right} -S ${fsampleN}.sam
	 ;;
	s | S | Single)
	 for Uni in `cat ${3}`; do
	    find `pwd` -mindepth ${mindepth:=1} -maxdepth ${maxdepth:=2} -type f -name ${Uni} >> Uni.txt
	 done
	 uni=$(awk '{{printf"%s,",$0}}' Uni.txt)
	 if [ "${4}" = "00" ]; then
		mode=${5}
		else
		MODE ${4}
	 fi
	 bowtie2 --rg-id ${FAMID} --rg "PL:${Platform}" --rg "SM:$(basename ${fsampleN})" ${mode} -x ${reference} -U ${uni} -S ${fsampleN}.sam
	 ;;
	*)
	 echo
	 ;;
    esac
   #---------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 CGATOOLS(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <arguments> \nExample:\t$FUNCNAME <...>"
   else
 
  echo 
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 NOVOALIGN(){
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t NOVOALIGN <path/>"
      else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
       Outfolder=${Infolder}
      else
       Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   mkdir -p ${Outfolder}/output
   Outfolder=${Outfolder}/output
    novoalign index
   #---------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 Sort_Bam() {
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t BWA_ALIGN <path/>"
      else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
      Outfolder=${Infolder}
     else
      Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   mkdir -p ${Outfolder}/output
   Outfolder=${Outfolder}/output
   if [ $InfileE = bam ]; then
     java -jar $PICARD/SortSam.jar INPUT=${Infile} OUTPUT=${Outfolder}/${InfileN}.sort.bam SORT_ORDER=coordinate
     java -jar $PICARD/MarkDuplicates.jar INPUT=${Outfolder}/${InfileN}.sort.bam OUTPUT=${Outfolder}/${InfileN}.dd.bam METRICS_FILE=${Outfolder}/${InfileN}.dd.metrics MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000
     samtools index ${Outfolder}/${InfileN}.dd.bam
    else
      if [ $InfileE = sam ]; then
        samtools view -bS $Infile > ${Outfolder}/${InfileN}.bam
        Sort_Bam ${Outfolder}/${InfileN}.bam
       else
        echo "Dear User, the input file is not the sam/bam file.. please check again, I am exiting now..."
        exit
      fi
   fi
   #------------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder BIA BIP
 }
### Mapping functions end...
## samtools functions ... samtools 1.1
 SAMTOOLS_Settings(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t $FUNCNAME <arguments> \nExample:\t$FUNCNAME <genome build>"
   else
    case "$1" in
        HG18 | hg18)
	 cosmic=hg18_cosmic_v54_120711.vcf
	 ;;
	hg19 | HG19 | GRC37)
         reference=$DATABASE/UCSC/homo/hg19.fasta
	 ;;
	MM9 | mm9)
	 reference=Mus_musculus_assembly9.fasta
	 dbsnp=dbsnp_128_mm9.vcf
	 ;;
	*)
	 echo "There is no genome build info provided.."
	 ;;
    esac
      if [ -r ${reference}.fai ]; then
	echo 
	else
         samtools faidx $reference
      fi
  fi
 }
 SAMTOOLS_caller(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t $FUNCNAME <Infile> <genome build> <mode> <Outfolder(optional)>\n\n\tmode: 1 (Call SNPs and short INDELs for one diploid individual)\n\t      2 (Call somatic mutations from a pair of samples-default)\n\t      3 (Call de novo and somatic mutations from a family trio) \nExample:\t$FUNCNAME infile.bam hg19 1 ./"
   else
    INFILE $1	# Infile name....
    SAMTOOLS_Settings $2
    if [ "${InfileE}" = sam ]; then
	samtools view -bt ${reference}.fai ${Infile} > ${Infolder}/{InfileN}.bam
	Infile=${Infolder}/{InfileN}.bam
    fi
    fmode=$3
    if [ "$4" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$4
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
    case "${fmode:=1}" in
	1)
	 samtools mpileup -f ${reference} -ug ${Infile} | bcftools call -vmO z -o ${Outfolder}/${InfileN}.vcf.gz
	 ;;
	2)
	 samtools mpileup -f ${reference} -t DP -t SP -u ${Infile} | bcftools call -vmTO z -o ${Outfolder}/${InfileN}.vcf.gz
	 ;;
	3)
	 samtools mpileup -f ${reference} -t DP -t SP -u ${Infile} | bcftools call -vmTO z -o ${Outfolder}/${InfileN}.vcf.gz
	 ;;
	*)
	 samtools mpileup -P ILLUMINA -f ${reference} -ug ${Infolder}/*.bam | bcftools call -vmO z -o ${Outfolder}/${InfileN}.vcf.gz
	 ;;
    esac
     tabix -p vcf ${Outfolder}/${InfileN}.vcf.gz
     bcftools stats -F ${reference} -s - ${Outfolder}/${InfileN}.vcf.gz > ${Outfolder}/${InfileN}.vcf.stats
     plot-vcfstats -p ${Outfolder}/${InfileN}.vcf.stats
   # bcftools view ${Outfolder}/${InfileN}.bcf | vcfutils.pl varFilter -D 2000 > ${Outfolder}/${InfileN}.vcf
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
### samtools functions end..
## GATK functions ....GATK 3.3.0
 GATK_Settings(){
  if [ -z "$1" ]; then

    echo -e "Usage: \n \t $FUNCNAME <genome build> \nExample:\t$FUNCNAME hg19"
   else
    case "$1" in
        HG18 | hg18)
	 cosmic=hg18_cosmic_v54_120711.vcf
	 ;;
	hg19 | HG19 | GRC37)
        #reference=$DATABASE/GATK/ucsc.hg19.fasta
         reference=$DATABASE/UCSC/homo/hg19.fasta
         dbsnp=$DATABASE/GATK/dbsnp_138.hg19.vcf
         hapmap=$DATABASE/GATK/hapmap_3.3.hg19.vcf
	 kgindels=$DATABASE/GATK/Mills_and_1000G_gold_standard.indels.hg19.vcf
	 kgsnps=$DATABASE/GATK/1000G_phase1.snps.high_confidence.hg19.vcf
	 kgomni=$DATABASE/GATK/1000G_omni2.5.hg19.vcf
	 cosmic=$DATABASE/GATK/Cosmic_v68.vcf
	 ;;
	MM9 | mm9)
	 reference=Mus_musculus_assembly9.fasta
	 dbsnp=dbsnp_128_mm9.vcf
	 ;;
	*)
	 echo "There is no genome build info provided.."
	 ;;
    esac
  fi
 }
 GATK_realign(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t $FUNCNAME <infile.bam> <genome build> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.bam hg19\n\t\t$FUNCNAME infile.bam hg19 ./"
  else
   INFILE $1	# Infile name....
   GATK_Settings $2
   if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
   fi
   Outfolder=${Outfolder%/}
   mkdir ${Outfolder}/${FUNCNAME}
   Outfolder=${Outfolder}/${FUNCNAME}
   # RealignerTargetCreator--Indels
   java -jar $GATK -T RealignerTargetCreator\
    -R $reference\
    -I $Infile\
    -known ${kgindels}\
    -o ${Outfolder}/${InfileN}.realigner.intervals
   # IndelRealigner
   java -jar $GATK -T IndelRealigner\
    -R $reference\
    -I $Infile\
    -known ${kgindels}\
    -targetIntervals ${Outfolder}/${InfileN}.realigner.intervals\
    -o $Outfolder/${InfileN}.realn.${InfileE}
   # BaseRecalibrator
   java -jar $GATK -T BaseRecalibrator\
    -R $reference\
    -I $Outfolder/${InfileN}.realn.${InfileE}\
    -knownSites ${dbsnp}\
    -knownSites ${kgindels}\
    -o $Outfolder/${InfileN}.recal.table
   # PrintReads
   java -jar $GATK -T PrintReads\
    -R $REF\
    -I $Outfolder/${InfileN}.realn.${InfileE}\
    -BQSR $Outfolder/${InfileN}.recal.table\
    -o $Outfolder/${InfileN}.recal.${InfileE}
   # BaseRecalibrator
   java -jar $GATK -T BaseRecalibrator\
    -R $reference\
    -I $Outfolder/${InfileN}.realn.${InfileE}\
    -knownSites $dbsnp\
    -knownSites $kgindels\
    -BQSR $Outfolder/${InfileN}.recal.table\
    -o $Outfolder/${InfileN}.af_recal.table
   # AnalyzeCovariates
   java -jar $GATK -T AnalyzeCovariates\
    -R $REF\
    -before $Outfolder/${InfileN}.recal.table\
    -after $Outfolder/${InfileN}.af_recal.table\
    -plots $Outfolder/${InfileN}.recal.plots.pdf

    # Unset $var used in function----------------------------------
  fi
  unset 
 }
 GATK_UniGT(){
  if [ -z "$1" ]; then
 
     echo -e "Usage: \n \t $FUNCNAME <infile.bam> <genome build> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.bam hg19\n\t\t$FUNCNAME infile.bam hg19 ./"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME} 
    # UnifiedGenotyper
    java -jar $GATK -T UnifiedGenotyper -R $reference -I $Infile -o $Outfolder/${InfileN}.vcf -stand_call_conf 30 -stand_emit_conf 10
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 GATK_HapCaller(){
  if [ -z "$1" ]; then
 
     echo -e "Usage: \n \t $FUNCNAME <infile.bam> <genome build> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.bam hg19\n\t\t$FUNCNAME infile.bam hg19 ./"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
   # HaplotypeCaller
   java -jar $GATK -T HaplotypeCaller -R $reference -I $Infile -o $Outfolder/${InfileN}.vcf -stand_call_conf 30 -stand_emit_conf 10 -minPruning 3
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 GATK_DOC(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <arguments> \nExample:\t$FUNCNAME <...>"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME} 
   # DepthOfCoverage--bam 
	java -jar $GATK -T DepthOfCoverage -R ${reference} -I $Infile -o ${Outfolder}/${InfileN}.csv -geneList:REFSEQ $DATABASE/lib/edited_ucsc_refgene_sorted_exons.txt -L $DATABASE/lib/NMD_329_refg_sorted_exons.bed -ct 1 -ct 5 -ct 10 -ct 15 -ct 20 -ct 30 -ct 50
 
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 GATK_VCF(){
  if [ -z "$1" ]; then
 
     echo -e "Usage: \n \t $FUNCNAME <infile.vcf> <genome build> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.vcf hg19\n\t\t$FUNCNAME infile.vcf hg19 ./"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME} 
   # VariantRecalibrator--SNPs
	java -jar $GATK -T VariantRecalibrator -R ${reference} -input ${Infile} -recalFile ${Outfolder}/${InfileN}.SNPs.recal -tranchesFile ${Outfolder}/${InfileN}.SNPs.tranches -rscriptFile ${Outfolder}/${InfileN}.SNPs.recal.plots -resource:hapmap,known=false,training=true,truth=true,prior=15.0 ${hapmap} -resource:omni,known=false,training=true,truth=true,prior=12.0 ${kgomni} -resource:1000G,known=false,training=true,truth=false,prior=10.0 ${kgsnps} -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${dbsnp} -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP -an InbreedingCoeff -mode SNP
   # ApplyRecalibration--SNPs
	java -jar $GATK -T ApplyRecalibration -R ${reference} -input ${Infile} -mode SNP -recalFile ${Outfolder}/${InfileN}.SNPs.recal -tranchesFile ${Outfolder}/${InfileN}.SNPs.tranches -o ${Outfolder}/${InfileN}.recal.SNPs.vcf -ts_filter_level 99.5
   # VariantRecalibrator--INDELs
	java -jar $GATK -T VariantRecalibrator -R $reference -input $Infile -recalFile ${Outfolder}/${InfileN}.INDELs.recal -tranchesFile ${Outfolder}/${InfileN}.INDELs.tranches -rscriptFile ${Outfolder}/${InfileN}.INDELs.recal.plots --maxGaussians 4 -resource:mills,known=false,training=true,truth=true,prior=12.0 ${kgindels} -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${dbsnp} -an QD -an DP -an FS -an SOR -an ReadPosRankSum -an MQRankSum -an InbreedingCoeff -mode INDEL
   # ApplyRecalibration--INDELs
	java -jar $GATK -T ApplyRecalibration -R $reference -input $Infile -mode INDEL -recalFile ${Outfolder}/${InfileN}.INDELs.recal -tranchesFile ${Outfolder}/${InfileN}.INDELs.tranches -o ${Outfolder}/${InfileN}.recal.INDELs.vcf -ts_filter_level 99.0
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 GATK_Trans(){
  if [ -z "$1" ]; then
 
     echo -e "Usage: \n \t $FUNCNAME <infile.vcf> <genome build> <ped file> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.vcf hg19 Family.ped \n\t\t$FUNCNAME infile.vcf hg19 family.ped ./"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    Inped=$3
    if [ "$4" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$4
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
    # PhaseByTransmission
    java -jar $GATK -T PhaseByTransmission -R $REF -input $Infile -ped ${Inped} -o ${Outfolder}/${InfileN}.phased.${InfileE}
    # Unset $var used in function----------------------------------
   fi
   unset 
 }
 GATK_RBP(){
  if [ -z "$1" ]; then
 
     echo -e "Usage: \n \t $FUNCNAME <infile.bam> <genome build> <Original vcf> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.bam hg19 original.vcf \n\t\t$FUNCNAME infile.bam hg19 original.vcf ./"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    Orivcf=$3
    if [ "$4" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$4
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
    # ReadBackedPhasing
    java -jar $GATK -T ReadBackedPhasing -R $reference -I $Infile -V ${Orivcf} -o ${Outfolder}/${InfileN}.phased.vcf -respectPhasinput
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 GATK_snpEff(){
  if [ -z "$1" ]; then
 
     echo -e "Usage: \n \t $FUNCNAME <infile.vcf> <genome build> <Outfolder(optional)> \nExample:\t$FUNCNAME infile.vcf hg19 \n\t\t$FUNCNAME infile.vcf hg19 ./"
   else
    INFILE $1	# Infile name....
    GATK_Settings $2
    if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
    # VariantAnnotator
    java -jar $GATK -T VariantAnnotator -R $reference -A SnpEff --variant $Infile --snpEffFile ${Outfolder}/{InfileN}.snpEff.${InfileE} -o ${Outfolder}/{InfileN}.annotated.${InfileE}
   # Unset $var used in function----------------------------------
   fi
   unset 
 }
 MuTect(){
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t $FUNCNAME <genome build> <path/tumor.bam> <path/normal.bam> <path/intervals> <Outfolder(optional)>"
   else
    GATK_Settings $1	# Infile name....
    INFILE $2
    TumorIn=${Infile}
    TumorInF=$(dirname ${TumorIn})
    TumorInN=$(basename ${TumorIn}); TumorInN=${TumorInN%.*}
    TumorInE=${TumorIn##*.}
    INFILE $3
    NormalIn=${Infile}
    intervals=$4
    if [ "$5" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$5
    fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
    #MuTect
    java -jar $muTect --analysis_type MuTect --reference_sequence ${reference} --cosmic ${cosmic} --dbsnp ${dbsnp} --intervals ${intervals} --input_file:normal $NormalIn --input_file:tumor $TumorIn --out ${Outfolder}/${TumorInN}.call_stats.out --coverage_file ${Outfolder}/${TumorInN}.coverage.wig.txt
   # Unset $var used in function----------------------------------
   fi
   unset GV TumorIn TumorInF TumorInN TumorInE NormalIn intervals Outfolder reference dbsnp cosmic Infile
 }
### GATK functions end.... 
## BAM file operations ..
### BAM file operations end ...
## VCF functions ....
 Sort_VCF() {
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t BWA_ALIGN <path/>"
      else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
      Outfolder=${Infolder}
     else
      Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   if [ ${InfileE} = "gz" ]; then
     gunzip ${Infile}
     Infile=${Infile%.*}
     bgzip ${Infile}
     tabix -p vcf ${Infile}.gz
    else
     bgzip ${Infile}
     tabix -p vcf ${Infile}.gz
   fi
   #-----------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 numcols() {
  # Take a line (1st by default) of a table and output columns as lines with leading number 
  head -${2:-1} ${1} | tail -1 | transpose -t | awk '{print NR,$0}'
 }
 addchr() {
  # add chr in front of lines staring with 0-9XYM
  # leaves any other line unchanged
  # should work with most BED and VCF files
  # accepts both piped data and file
  if [ "$#" -lt 1 ]
  then
  cat | gawk 'BEGIN{FS="\t"; OFS="\t"}
        {if ($1~/^[0-9XYM]/)
               {gsub($1,"chr"$1,$1); 
                print $0
                } else print $0
        }'
  else gawk 'BEGIN{FS="\t"; OFS="\t"}
	{if ($1~/^[0-9XYM]/)
		{gsub($1,"chr"$1,$1); 
		print $0
		} else print $0
	}' $1
  fi
  }
 remchr() {
  # removes chr in front of lines staring with chr
  # leaves any other line unchanged
  # should work with most BED and VCF files
  # accepts both piped data and file
  if [ "$#" -lt 1 ]
  then
  cat | gawk 'BEGIN{FS="\t"; OFS="\t"}
	{if ($1~/^chr/){
		gsub("chr","",$1); 
		print $0
		} else print $0
	}'
  else
  gawk 'BEGIN{FS="\t"; OFS="\t"}
	{if ($1~/^chr/){
		gsub("chr","",$1); 
		print $0
		} else print $0
	}' $1
  fi
  }
 SPLITVCF() {
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t SPLITVCF <path/>"
      else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   if [ ${InfileE} != "vcf" ]; then
    extract ${Infile}
    Infile=${Infile%.*}; InfileN=$(basename ${Infile}); InfileN=${InfileN%.*}; InfileE=${Infile##*.}
   fi
     # SNPs
     vcftools --vcf ${Infile} --remove-indels --out ${Outfolder}/SNPs_${InfileN} --recode
     mv ${Outfolder}/SNPs_${InfileN}.recode.vcf ${Outfolder}/SNPs_${InfileN}.${InfileE}
     # INDELS
     vcftools --vcf ${Infile} --keep-only-indels --out ${Outfolder}/INDELs_${InfileN} --recode 
     mv ${Outfolder}/INDELs_${InfileN}.recode.vcf ${Outfolder}/INDELs_${InfileN}.${InfileE}
     Sort_VCF ${Outfolder}/SNPs_${InfileN}.${InfileE} &
     Sort_VCF ${Outfolder}/INDELs_${InfileN}.${InfileE} &
    wait
   #------------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 FILTERVCF() {
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t FILTERVCF <path/>"
     else
   INFILE $1	# Infile name....
  if [ "$InfileE" != "vcf" ]; then
   extract $Infile
   Infile=${Infile%.*}
   InfileN=${InfileN%.*}
   fi
   TARGETR=$2
   TARGETRN=$(basename "${TARGETR}"); TARGETRN=${TARGETRN%.*}
   vcftools --vcf ${Infile} --bed ${TARGETR} --recode --recode-INFO-all --out ${Infolder}/${InfileN}_${TARGETRN}_only
   #-----------------------------------------
  fi
  unset Infile Infolder InfileN InfileE TARGETR TARGETRN
 }
 VCF2GENE(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <path/Infile.vcf/bcf> <Genes list> \nExample:\t$FUNCNAME <./Infile.vcf> <$DATADIR/data/database/HGNC.txt"
   else
    INFILE $1
    if [ "$2" = "" ] && [ -r $2 ]; then
       echo -e "Usage: \n \t $FUNCNAME <path/Infile.vcf/bcf> \nExample:\t$FUNCNAME <./Infile.vcf>"
      else
      GENELIST=$2
     if [ "$3" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$3
     fi
      Outfolder=${Outfolder%/}
      mkdir ${Outfolder}/${FUNCNAME}
      Outfolder=${Outfolder}/${FUNCNAME} 
      for GENE in `cat $GENELIST`; do
	grep -v "^##" $Infile | grep $GENE > $Outfolder/${GENE}.${InfileN}.${InfileE}
      done
    fi
   # Unset $var used in function----------------------------------
   fi
   unset Infile Infolder InfileN InfileE GENELIST Outfolder GENE
 }
 VCF2CHR(){
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo -e "Usage: \n \t $FUNCNAME <path/Infile.vcf/bcf> <Output folder (optional)>\nExample:\t$FUNCNAME <./Infile.vcf>"
   else
    INFILE $1
     if [ "$2" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$2
     fi
    Outfolder=${Outfolder%/}
    mkdir ${Outfolder}/${FUNCNAME}
    Outfolder=${Outfolder}/${FUNCNAME}
    for CHR in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY chrM; do
	grep "^${CHR}[[:space:]]" $Infile > $Outfolder/${CHR}.${InfileN}.${InfileE}
    done
   # Unset $var used in function----------------------------------
   fi
   unset Infile Infolder InfileN InfileE Outfolder CHR
 }
### VCF functions end...
## ANNOVAR functions ....
 ANNOVAR_Filter() {
  if [ -z "$1" ]; then
     echo -e "Usage: \n \t ANNOVAR_Filter <path/ANNOVAR.vcf>"
      else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   mkdir ${Outfolder}/${FUNCNAME}
   Outfolder=${Outfolder}/${FUNCNAME}
   mkdir -p ${Outfolder}/{novel,reported,clinvar}
  if [ "$3" = "" ]; then
	echo -e ""frameshift_insertion"\n"frameshift_deletion"\n"frameshift_block_substitution"\n"stopgain"\n"stoploss"\n"nonframeshift_insertion"\n"nonframeshift_deletion"\n"nonframeshift_block_substitution"\n"nonsynonymous_SNV"\n"synonymous_SNV"\n"unknown"" > /tmp/exonicF.txt
	exonicF="/tmp/exonicF.txt"
	else 
	exonicF=$3
  fi
  SAMPLETYPE=${SAMPLETYPE:=N}
  AFREPORT=$Outfolder/${InfileN}.report.txt
  touch ${AFREPORT}
  NOVARs=$Outfolder/${InfileN}.novars.txt
  touch ${NOVARs}
  Fvars=$Outfolder/${InfileN}.final.vars.csv
  touch ${Fvars}
  CANVARs=$Outfolder/${InfileN}.candidate.vars.csv
  touch ${CANVARs}
  if [ $InfileE = "csv" ]; then
  # For csv
   Header=$(head -n1 $Infile)
   NMHeader=1
   echo ${Header} >> ${CANVARs}
   gawk -v Outfolder="$Outfolder"\
   -v InfileN="$InfileN"\
   -v HEADER="$Header"\
   -v a="exonic splicing ncRNA_exonic ncRNA_intronic UTR3 UTR5 intronic upstream downstream intergenic na"\
   -v b="frameshift_insertion frameshift_deletion frameshift_block_substitution stopgain stoploss nonframeshift_insertion nonframeshift_deletion nonframeshift_block_substitution nonsynonymous_SNV synonymous_SNV unknown na"\
   -v InfileE="$InfileE"\
   -v K="$Outfolder/reported/${InfileN}.report"\
   -v N="$Outfolder/novel/${InfileN}.novel"\
   -v C="$Outfolder/clinvar/${InfileN}.clinvar"\
   -v U="$Outfolder/${InfileN}.UNKNOWN"\
   -v e="\"?na\"?$"\
   -v D="\"?D\"?"\
   -v PD="\"?[DP]\"?"\
   -v HM="\"?[HM]\"?"\
   -v E="^\"?exonic"\
   -v NSNV="^\"?nonsynonymous SNV"\
   'BEGIN{
    FS="[,]"
    aN=split(a,A," ");
    bN=split(b,B," ");
    for(i=1;i<=aN;i++)
       {
        KAf=K"."A[i]"."InfileE;
         print HEADER > KAf
         close(KAf);
        NAf=N"."A[i]"."InfileE;
         print HEADER > NAf
         close(NAf);
        CAf=C"."A[i]"."InfileE;
	 print HEADER > CAf
	 close(CAf);
        for(I=1;I<=bN;I++)
          {
	   gsub(/_/, " ", B[I])
	   KBf=K".exonic."B[I]"."InfileE;
	    print HEADER > KBf
	    close(KBf);
	   KBSP=K".exonic.nonsynonymous"" ""SNV.S.P."InfileE;
	    print HEADER > KBSP
	    close(KBSP);
	   NBf=N".exonic."B[I]"."InfileE;
	    print HEADER > NBf
	    close(NBf);
	   NBSP=N".exonic.nonsynonymous"" ""SNV.S.P."InfileE;
	    print HEADER > NBSP
	    close(NBSP);
	   CBf=C".exonic."B[I]"."InfileE;
	    print HEADER > CBf
	    close(CBf);
	   CBSP=C".exonic.nonsynonymous"" ""SNV.S.P."InfileE;
	    print HEADER > CBSP
	    close(CBSP);
	   KBspLM=K".exonic.nonsynonymous"" ""SNV.S.P.LRT.MT.MA."InfileE;
	    print HEADER > KBspLM
	     close(KBspLM);
           NBspLM=N".exonic.nonsynonymous"" ""SNV.S.P.LRT.MT.MA."InfileE;
	    print HEADER > NBspLM
	     close(NBspLM);
           CBspLM=C".exonic.nonsynonymous"" ""SNV.S.P.LRT.MT.MA."InfileE;
	    print HEADER > CBspLM
	     close(CBspLM);
	  }
       }
   }
   {
    KBSP=K".exonic.nonsynonymous"" ""SNV.S.P."InfileE;
    NBSP=N".exonic.nonsynonymous"" ""SNV.S.P."InfileE;
    CBSP=C".exonic.nonsynonymous"" ""SNV.S.P."InfileE;
    KBspLM=K".exonic.nonsynonymous"" ""SNV.S.P.LRT.MT.MA."InfileE;
    NBspLM=N".exonic.nonsynonymous"" ""SNV.S.P.LRT.MT.MA."InfileE;
    CBspLM=C".exonic.nonsynonymous"" ""SNV.S.P.LRT.MT.MA."InfileE;
    for(i=1;i<=aN;i++)
	 {
          KAf=K"."A[i]"."InfileE;
	  NAf=N"."A[i]"."InfileE;
	  CAf=C"."A[i]"."InfileE;
	  GF="^\"?"A[i]
	  if($6~GF && ($13!~e || $14!~e || $15!~e))
	   {print $0 >> KAf
	   close(KAf);}
	  else if($6~GF && $13~e && $14~e && $15~e)
	   {print $0 >> NAf
	   close(NAf);}
	  else if($6~GF && ($41!~e || $42!~e || $43!~e))
	   {print $0 >> CAf
	   close(CAf);}
	  else if($6~GF && $41!~e && $42!~/^$/ && $43~/^$/)
	   {print $0 >> CAf
	   close(CAf);}
	 }
    for(I=1;I<=bN;I++)
	 {
	  KBf=K".exonic."B[I]"."InfileE;
	  NBf=N".exonic."B[I]"."InfileE;
	  CBf=C".exonic."B[I]"."InfileE;
	  gsub(/_/, " ", B[I])
	  BF="^\"?"B[I]
          if($6~E && $9~BF && ($13!~e || $14!~e || $15!~e))
	   {print $0 >> KBf
            close(KBf);}
	  else if($6~E && $9~BF && $13~e && $14~e && $15~e)
	   {print $0 >> NBf
            close(NBf);}
	  else if($6~E && $9~BF && ($41!~e || $42!~e || $43!~e))
	   {print $0 >> CBf
            close(CBf);}
	  else if($6~E && $9~BF && $41!~e && $42!~/^$/ && $43~/^$/)
	   {print $0 >> CBf
            close(CBf);}
	 }
    if($6~E && $9~NSNV && ($13!~e || $14!~e || $15!~e) && $17~D && $19~PD && $21~PD)
     {print $0 >> KBSP
      close(KBSP);}
    else if($6~E && $9~NSNV && $13~e && $14~e && $15~e && $17~D && $19~PD && $21~PD)
     {print $0 >> NBSP
      close(NBSP);}
    else if($6~E && $9~NSNV && $17~D && $19~PD && $21~PD && ($41!~e || $42!~e || $43!~e))
     {print $0 >> CBSP
      close(CBSP);}
    else if($6~E && $9~NSNV && $17~D && $19~PD && $21~PD && $41!~e && $42!~/^$/ && $43~/^$/)
     {print $0 >> CBSP
      close(CBSP);}
    if($6~E && $9~NSNV && ($13!~e || $14!~e || $15!~e) && $17~D && $19~PD && $21~PD && $23~D && $25~D && $27~HM)
     {print $0 >> KBspLM
      close(KBspLM);}
    else if($6~E && $9~NSNV && $13~e && $14~e && $15~e && $17~D && $19~PD && $21~PD && $23~D && $25~D && $27~HM)
     {print $0 >> NBspLM
      close(NBspLM);}
    else if($6~E && $9~NSNV && $17~D && $19~PD && $21~PD && ($41!~e || $42!~e || $43!~e) && $23~D && $25~D && $27~HM)
     {print $0 >> CBspLM
      close(CBspLM);}
    else if($6~E && $9~NSNV && $17~D && $19~PD && $21~PD && $23~D && $25~D && $27~HM && $41!~e && $42!~/^$/ && $43~/^$/)
     {print $0 >> CBspLM
      close(CBspLM);}
   }
   ' $Infile
  else
  # For vcf
   # Header
   grep "^#" $Infile > ${Outfolder}/${InfileN}.header.${InfileE}
   cat ${Outfolder}/${InfileN}.header.${InfileE} >> ${CANVARs}
   NMHeader=`gawk 'END{print NR}' ${Outfolder}/${InfileN}.header.${InfileE}`
   # Shorten names
   HEADER=${Outfolder}/${InfileN}.header.${InfileE}
   KNOWN=$Outfolder/reported/${InfileN}.report
   NOVEL=$Outfolder/novel/${InfileN}.novel
   CLINVAR=$Outfolder/clinvar/${InfileN}.clinvar
   UNKNOWN=$Outfolder/${InfileN}.UNKNOWN
   REFANNTD=$Outfolder/${InfileN}.REFANNTD
   e=na
   COMDB="esp6500siv2_all\=${e}\;1000g2014oct_all\=${e}\;snp${dbSNPV:=138}\=${e}\;"
   CLINDBT="clinvar_20140929\=${e}\;cosmic70\=\.\;nci60\=${e}\;"
   CLINDBN="clinvar_20140929\=${e}\;"
   SIFT="SIFT_score\=0.0[1-5]"
   PPHDIV="HDIV_pred\=[D|P]"
   PPHVAR='HVAR_pred\=[D|P]'
   LRT="LRT_pred\=D"
   MTP="MutationTaster_pred\=D"
   MAP="MutationAssessor_pred\=[H|M]"
   cat ${HEADER} > ${UNKNOWN}.${InfileE}
   cat ${HEADER} > ${REFANNTD}.${InfileE}
   grep -v "^#" $Infile | grep "Func\.refGene\=${e}\;Gene" >> ${UNKNOWN}.${InfileE}
   grep -v "^#" $Infile | grep -Ev "Func\.refGene\=${e}\;Gene" >> ${REFANNTD}.${InfileE}
   ## Gene based filter
   for GBF in exonic splicing ncRNA UTR5 UTR3 intronic upstream downstream intergenic; do
    # Header
    cat ${HEADER} > ${KNOWN}.${GBF}.${InfileE}
    cat ${HEADER} > ${NOVEL}.${GBF}.${InfileE}
    cat ${HEADER} > ${CLINVAR}.${GBF}.${InfileE}
    # known
    grep -v "^#" ${REFANNTD}.${InfileE} | grep -Ev ${COMDB} | grep Func\.refGene\=${GBF} >> ${KNOWN}.${GBF}.${InfileE}
    # Novel
    grep -v "^#" ${REFANNTD}.${InfileE} | grep -E ${COMDB} | grep Func\.refGene\=${GBF} >> ${NOVEL}.${GBF}.${InfileE}
    # Clinvar 
    if [ ${SAMPLETYPE:=N} = "T" ]; then
	grep -v "^#" ${REFANNTD}.${InfileE} | grep -Ev ${CLINDBT} | grep Func\.refGene\=${GBF} >> ${CLINVAR}.${GBF}.${InfileE}
      else
        grep -v "^#" ${REFANNTD}.${InfileE} | grep -Ev ${CLINDBN} | grep Func\.refGene\=${GBF} >> ${CLINVAR}.${GBF}.${InfileE}
    fi
   done &
   wait
   ## Exonic variant function annotations
   for RPM in `cat ${exonicF}`; do
	if [ ${RPM} = "nonsynonymous_SNV" ]; then
	  cat ${HEADER} > ${KNOWN}.exonic.S.P.${InfileE}
	  cat ${HEADER} > ${KNOWN}.exonic.S.P.LRT.MT.MA.${InfileE}
	  cat ${HEADER} > ${NOVEL}.exonic.S.P.${InfileE}
	  cat ${HEADER} > ${NOVEL}.exonic.S.P.LRT.MT.MA.${InfileE}
	  cat ${HEADER} > ${CLINVAR}.exonic.S.P.${InfileE}
	  cat ${HEADER} > ${CLINVAR}.exonic.S.P.LRT.MT.MA.${InfileE}
	 # Known SNVs
	  grep ${RPM} ${KNOWN}.exonic.${InfileE} | grep ${SIFT} | grep -E ${PPHDIV} | grep -E ${PPHVAR} >> ${KNOWN}.exonic.S.P.${InfileE}
	  grep -E "${LRT}|${MTP}|${MAP}" ${KNOWN}.exonic.S.P.${InfileE} >> ${KNOWN}.exonic.S.P.LRT.MT.MA.${InfileE}
	 # Novel SNVs
	  grep ${RPM} ${NOVEL}.exonic.${InfileE} | grep ${SIFT} | grep -E ${PPHDIV} | grep -E ${PPHVAR} >> ${NOVEL}.exonic.S.P.${InfileE}
	  grep -E "${LRT}|${MTP}|${MAP}" ${NOVEL}.exonic.S.P.${InfileE} >> ${NOVEL}.exonic.S.P.LRT.MT.MA.${InfileE}
	 # Clinvar...
	  grep ${RPM} ${CLINVAR}.exonic.${InfileE} | grep ${SIFT} | grep -E ${PPHDIV} | grep -E ${PPHVAR} >> ${CLINVAR}.exonic.S.P.${InfileE}
	  grep -E "${LRT}|${MTP}|${MAP}" ${CLINVAR}.exonic.S.P.${InfileE} >> ${CLINVAR}.exonic.S.P.LRT.MT.MA.${InfileE}
	else
	  cat ${HEADER} > ${KNOWN}.exonic.${RPM}.${InfileE}
	  cat ${HEADER} > ${NOVEL}.exonic.${RPM}.${InfileE}
	  cat ${HEADER} > ${CLINVAR}.exonic.${RPM}.${InfileE}
	 # Known
	  grep -E "\=${RPM}" ${KNOWN}.exonic.${InfileE} >> ${KNOWN}.exonic.${RPM}.${InfileE}
	 # Novel
	  grep -E "\=${RPM}" ${NOVEL}.exonic.${InfileE} >> ${NOVEL}.exonic.${RPM}.${InfileE}
	 # Clinvar
	  grep -E "\=${RPM}" ${CLINVAR}.exonic.${InfileE} >> ${CLINVAR}.exonic.${RPM}.${InfileE}
	fi
   done &
   wait
  fi
  # Generate report and remove empty file and folder
   ls -R $Outfolder | grep ${InfileN} > $Outfolder/${InfileN}.txt
   NMInfile=$(gawk 'END{print NR}' ${Infile})
   TONM=$[$NMInfile - $NMHeader]
   echo -e "This is sample ${InfileN} 's report: \n There are total ${TONM} variants annotated and reported by ANNOVAR \n" >> "${AFREPORT}"
   echo -e "Those functions of genes are not detected any variant in this sample: \n" >> "${NOVARs}"
   while read RPMA; do
	AFInfile=$(find `pwd` -type f -name "${RPMA}")
	AFInfileN=$(basename "${AFInfile}")
	AFInfileD=$(dirname "${AFInfile}")
        NumBS=$(gawk 'END{print NR}' "${AFInfile}")
	NMVAR=$[ $NumBS - $NMHeader ]
	if [ "${AFInfileD}" != "${Outfolder}" ]; then
	if [ ${NMVAR} -le 0 ]; then
		echo -e "There is no variant in this file: ${AFInfileN} \n" >> ${NOVARs}
		rm -rf "${AFInfile}"
	else
		echo -e "\n ${AFInfileN} \n There is"/"are variant's: ${NMVAR}\n" >> ${AFREPORT}
		if [ $InfileE = "csv" ]; then
		    head -n6 "${AFInfile}" >> ${AFREPORT}
		    if [ ${NMVAR} -gt 5 ]; then
			echo -e "\n Please Goto original file, check the rest of variants. " >> ${AFREPORT}
		    fi
		  else
		    grep -A 5 "^#[Cc]" "${AFInfile}" >> ${AFREPORT}
		    if [ ${NMVAR} -gt 5 ]; then
			echo -e "\n Please Goto original file, check the rest of variants." >> ${AFREPORT}
		    fi
		fi
		case "${AFInfile}" in
			*.frameshift_insertion.vcf)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 grep -v "^##" "${AFInfile}" >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			"*.frameshift insertion.csv")
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 cat "${AFInfile}" >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.frameshift_deletion.vcf)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 grep -v "^##" ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			"*.frameshift deletion.csv")
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 cat "${AFInfile}" >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.frameshift_block_substitution.vcf)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 grep -v "^##" ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			"*.frameshift block substitution.csv")
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 cat "${AFInfile}" >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.stopgain.vcf)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 grep -v "^##" ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.stopgain.csv)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 cat ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.stoploss.vcf)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 grep -v "^##" ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.stoploss.csv)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 cat ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.S.P.vcf)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 grep -v "^##" ${AFInfile} >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*.S.P.csv)
			 echo -e "\n${AFInfileN}\n" >> ${Fvars}
			 cat "${AFInfile}" >> ${Fvars}
			 echo -e "\n" >> ${Fvars}
			;;
			*)
			echo -e "There are some problems in your infiles..."
			 ;;
		esac
	fi
        fi
   done <$Outfolder/${InfileN}.txt
   if [ "${CanGenes}" != "" ]; then
     while read CanGene; do
	grep ${CanGene} ${Fvars} | grep -v "Start" | grep -v "^#" >> ${CANVARs}
     done <${CanGenes}
    else
     echo "Dear User, you did not set candidate genes list...."
   fi
   find ${Outfolder}/ -type f -empty -print0 | xargs -0 -I {} /bin/rm "{}"
  #---------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder exonicF RPM GBF RPMA HEADER KNOWN NOVEL CLINVAR UNKNOWN REFANNTD AFREPORT COMDB CLINDBT CLINDBN SIFT PPHDIV PPHVAR LRT MTP MAP CanGene CanGenes CANVARs
 }
 ANNOVAR(){
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t $FUNCNAME <arguments> \nExample:\t$FUNCNAME Infile"
     else
  #preconfigure parameters 
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
	Outfolder=${Infolder}
	else
	Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   mkdir ${Outfolder}/${FUNCNAME}
   Outfolder=${Outfolder}/${FUNCNAME}
  #--------------------
   ANDB=${ANDB:=$DATADIR/data/database/ANDB}
   ANNOVAR_PROTOCOL=${ANNOVAR_PROTOCOL:=refGene,phastConsElements100way,genomicSuperDups,esp6500siv2_all,1000g2014oct_all,snp${dbSNPV:=138},ljb26_all,clinvar_20140929}
   ANNOVAR_operation=${ANNOVAR_operation:=g,r,r,f,f,f,f,f}
  #--------------------
   touch -f ${Outfolder}/${InfileN}.report.txt
   touch -f ${Outfolder}/${InfileN}.report.err.log
   ANRE=${Outfolder}/${InfileN}.report.txt
   ANEE=${Outfolder}/${InfileN}.report.err.log
  # Uncompressing Infile..
   case "${Infile}" in
	*.gz) 
	 gunzip ${Infile}
         Infile=${Infile%.*}
         InfileN=${InfileN%.*}
	 ;;
	*.bz2)
	 bunzip2 ${Infile}
         Infile=${Infile%.*}
         InfileN=${InfileN%.*}
	 ;;
	*)
	 echo ""
	 ;;
   esac
  # Report & Log title
   echo -e "Processing ANNOVAR analysis...." 1>> ${ANRE} 2>> ${ANEE}
   DIR_test ${Infolder} 1>> ${ANRE} 2>> ${ANEE}
   echo -e "Processing file is $Infile in ${InfileE} format, Using ${GV:=hg19} version reference" 1>> ${ANRE} 2>> ${ANEE}
   echo -e "All results are exported to ${Outfolder} \n" 1>> ${ANRE} 2>> ${ANEE}
  # Generate ANNOVAR processing analysis report
   echo -e "Inspect the first 5 calls in the In-put file \n" 1>> ${ANRE} 2>> ${ANEE}
   zgrep -v "^##" ${Infile} | head -6 | column -t 1>> ${ANRE} 2>> ${ANEE}
  # Initialization: Convert variants to ANNOVAR format
  echo -e "Initialization: Converting variants to ANNOVAR format..." 1>> ${ANRE} 2>> ${ANEE}
  # Infile convert2ANNOVAR input file
    if [ -f ${Infile} ] ; then
        case ${AVFormat:=vcf} in
            vcf | VCF)	FORMAT="vcf4" ;;
            cg | CG)	FORMAT="cg" ;;
            tsv)	FORMAT="cg" ;;
            gff | GFF)	FORMAT="gff3-solid" ;;
            vcf4old)	FORMAT="vcf4old" ;;
            pileup)	FORMAT="pileup" ;;
            soapsnp | SOAPsnp)	FORMAT="soapsnp" ;;
	    maq | MAQ)	FORMAT="maq" ;;
	    casava | CASAVA)	FORMAT="casava" ;;
            *)	echo "'${Infile}' cannot be converted to annovar input file." ;;
        esac
	  convert2annovar.pl -format ${FORMAT} ${Infile} -outfile ${Outfolder}/${InfileN}.avinput --includeinfo --comment --coverage 0 --genoqual 0 --varqual 0 -withfreq
      else
          echo "'$1' is not a valid file"
    fi
   echo -e "Inspecting the top-5 lines in the convert2annovar result \n" 1>> ${ANRE} 2>> ${ANEE}
   grep -v "^##" ${Outfolder}/${InfileN}.avinput | head -5 | column -t 1>> ${ANRE} 2>> ${ANEE}
  ## Genomic Annotation of the converted data using annotate_variation.pl
  echo -e "Gene-based Annotation of the converted data..." 1>> ${ANRE} 2>> ${ANEE}
  annotate_variation.pl \
	--buildver ${GV:=hg19} \
	--geneanno \
	${Outfolder}/${InfileN}.avinput \
	--outfile ${Outfolder}/${InfileN} \
	${ANDB}
   echo -e "Inspecting the top-5 lines in the intergenic variants annotated by ANNOVAR \n" 1>> ${ANRE} 2>> ${ANEE}
   head -5 ${Outfolder}/${InfileN}.variant_function | column -t 1>> ${ANRE} 2>> ${ANEE}
  # ANNOVAR matrics report:
   echo -e "\n" 1>> ${ANRE} 2>> ${ANEE}
   echo -e "There are `gawk 'END{print NR}' ${Outfolder}/${InfileN}.avinput` valid input, and `gawk 'END{print NR}' ${Outfolder}/${InfileN}.invalid_input` invalid input. \n" 1>> ${ANRE} 2>> ${ANEE}
   ValidSNVs=$(gawk 'END{print NR}' ${Outfolder}/${InfileN}.variant_function)
   echo -e "There are total ${ValidSNVs} valid variations annotated by refGene database \n Including: \n Total: ${ValidSNVs} \n" 1>> ${ANRE} 2>> ${ANEE}
   cut -f 1 ${Outfolder}/${InfileN}.variant_function | sort | uniq -c | sort -n 1>> ${ANRE} 2>> ${ANEE}
   echo -e "\n" 1>> ${ANRE} 2>> ${ANEE}
  # switch back to 0-based open coordinates
  # replace spaces by '_'  in name field
	gawk 'BEGIN{FS="\t"; OFS="\t"}
	 {
	 namef=$6"/"$7"|"$8"|"$2"|"$3"|DP="$10
	 gsub(/ /, "_", namef)
	 print $3, $4-1, $5, namef ,"+", $9
	 }' ${Outfolder}/${InfileN}.variant_function > ${Outfolder}/${InfileN}.variant_function.bed
  ##Exomic variants annotated by ANNOVAR
	if [ -s ${Outfolder}/${InfileN}.exonic_variant_function ]; then
	 echo -e "Inspecting the top-5 lines in the exonic variants annotated by ANNOVAR \n" 1>> ${ANRE} 2>> ${ANEE}
	 head -5 ${Outfolder}/${InfileN}.exonic_variant_function | column -t 1>> ${ANRE} 2>> ${ANEE}
	 echo -e "\n" 1>> ${ANRE} 2>> ${ANEE}
	 gawk 'BEGIN{FS="\t"; OFS="\t"}
	  {
	  namef=$7"/"$8"|"$9"|"$2"|"$3"|DP="$11
	  gsub(/ /, "_", namef)
	  print $4, $5-1, $6, namef, "+", $10
	  }' ${Outfolder}/${InfileN}.exonic_variant_function > \
	  ${Outfolder}/${InfileN}.exonic_variant_function.bed
	 echo -e "Identify interesting annotation categories in exonic variants...\n " 1>> ${ANRE} 2>> ${ANEE}
	 echo -e "There are total `gawk 'END{print NR}' ${Outfolder}/${InfileN}.exonic_variant_function` exonic variations: \n Including: \n" 1>> ${ANRE} 2>> ${ANEE}
	  cut -f 2 ${Outfolder}/${InfileN}.exonic_variant_function | sort | uniq -c | sort -n | tee ${Outfolder}/${InfileN}.exonic_report.txt 1>> ${ANRE} 2>> ${ANEE}
         cat ${Outfolder}/${InfileN}.exonic_report.txt | sed 's/^[[:space:]]*//' | sed 's/^[0-9]*//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]/\_/' | sed 's/[[:space:]]*$//' > ${Outfolder}/${InfileN}.c.txt
	  for VC in `cat ${Outfolder}/${InfileN}.c.txt`; do
	    grep "$VC" ${Outfolder}/${InfileN}.exonic_variant_function > ${Outfolder}/${InfileN}.exonic_variant_function.${VC}	
	  done
	 # fi
	else 
	 echo -e "There is no exonic variant in this sample.. \n" 1>> ${ANRE} 2>> ${ANEE}
	fi
  ##Affected genes list, and variations matrics based on variation types
   # echo -e "There are `cut -f 1 ${Outfolder}/${InfileN}.variant_function | sort | uniq -c | wc -l | gawk '{print $1}'` genes afftected, including:..(top-5 genes)\n More details you can open this file:XXXXX"
   # cut -f 1 ${Outfolder}/${InfileN}.variant_function | sort | uniq -c | head -5 | column -t 1>> ${ANRE} 2>> ${ANEE}
   # total. genes_list V1 V2 V3 V4 V5
  ##
   ## ANNOVAR_TABLE
   # checking "ANNOVAR_PROTOCOL", and testing weather the database is available 
   # Based on most recent databases, testing and generate ANNOVAR_operation value.
   if [ "${AVOUTPUT}" = "vcf" ]; then
    table_annovar.pl --vcfinput ${Infile} ${ANDB} -buildver ${GV:=hg19} -otherinfo -protocol ${ANNOVAR_PROTOCOL} -operation ${ANNOVAR_operation} -nastring na --remove --outfile ${Outfolder}/${InfileN}
    ANNOVAR_Filter ${Outfolder}/${InfileN}.${GV:=hg19}_multianno.vcf ${Outfolder} ${Outfolder}/${InfileN}.c.txt &
   else
    table_annovar.pl ${Outfolder}/${InfileN}.avinput ${ANDB} -buildver ${GV:=hg19} -otherinfo -protocol ${ANNOVAR_PROTOCOL} -operation ${ANNOVAR_operation} -nastring na --remove --csvout --outfile ${Outfolder}/${InfileN}
    ANNOVAR_Filter ${Outfolder}/${InfileN}.${GV:=hg19}_multianno.csv ${Outfolder} ${Outfolder}/${InfileN}.c.txt &
   fi
   #---------------------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder AVFormat
 }
 ANNOVAR_DB() {
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t ANNOVAR_DB <path/>"
     else
   #Gene-based databases download and prepare
   ANDB=${ANDB:=$DATADIR/data/database/ANDB/}
   annotate_variation.pl -build ${GV:=hg19} -downdb phastConsElements46way ${ANDB}
   #---------------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
 # TABLE_ANNOVAR: checking Input files format, checking protcol and operation settings
 TABLE_ANNOVAR() {
  if [ -z "$1" ]; then
    echo -e "Usage: \n \t TABLE_ANNOVAR <path/>"
     else
   INFILE $1	# Infile name....
   if [ "$2" = "" ]; then
 	Outfolder=${Infolder}
	else
	Outfolder=$2
   fi
   Outfolder=${Outfolder%/}
   mkdir ${Outfolder}/${FUNCNAME}
   Outfolder=${Outfolder}/${FUNCNAME}
   ANDB=${ANDB:=$DATADIR/data/database/ANDB/}
   ANNOVAR_PROTOCOL=${ANNOVAR_PROTOCOL:=refGene,phastConsElements100way,genomicSuperDups,esp6500siv2_all,1000g2014oct_all,snp${dbSNPV:=138},ljb26_all,clinvar_20140929}
   ANNOVAR_operation=${ANNOVAR_operation:=g,r,r,f,f,f,f,f}

   # testing infile format
    if [ -f ${Infile} ] ; then
        case $3 in
            vcf | VCF)	FORMAT="vcf4" ;;
            tsv | cg | CG)	FORMAT="cg" ;;
            gff | GFF)	FORMAT="gff3-solid" ;;
            vcf4old)	FORMAT="vcf4old" ;;
            pileup)	FORMAT="pileup" ;;
            soapsnp | SOAPsnp)	FORMAT="soapsnp" ;;
	    maq | MAQ)	FORMAT="maq" ;;
	    casava | CASAVA)	FORMAT="casava" ;;
            *)	echo "'${Infile}' cannot be converted to annovar input file." ;;
        esac
	  convert2annovar.pl -format ${FORMAT} ${Infile} -outfile ${Outfolder}/${InfileN}.avinput --includeinfo --comment --coverage 0 --genoqual 0 --varqual 0 -withfreq
      else
          echo "'$1' is not a valid file"
    fi
   # checking "ANNOVAR_PROTOCOL", and testing weather the database is available 
   # Based on most recent databases, testing and generate ANNOVAR_operation value.
    table_annovar.pl ${Outfolder}/${InfileN}.avinput ${ANDB} -buildver ${GV:=hg19} -otherinfo -protocol ${ANNOVAR_PROTOCOL} -operation ${ANNOVAR_operation} -nastring an --remove --csvout --outfile ${Outfolder}/${InfileN}
    ## ANNOVAR_Filter
   ANNOVAR_Filter ${Outfolder}/${InfileN}.${GV:=hg19}_multianno.csv ${Outfolder}/
   #-------------------------------
  fi
  unset Infile Infolder InfileN InfileE Outfolder
 }
ANNOVARDBs(){
  echo ">"
  cat << _ANNOVAR_DB_
    avsift	r	avsift
    ljb_sift	r	ljb_sift
    ljb2_sift	r	ljb2_sift
    ljb23_sift	r	ljb23_sift
    ljb26_sift	r	ljb26_sift
    ljb_pp2	r	ljb_pp2
    ljb2_pp2hdiv	r	ljb2_pp2hdiv
    ljb23_pp2hdiv	r	ljb23_pp2hdiv
    ljb26_pp2hdiv	r	ljb26_pp2hdiv
    ljb2_pp2hvar	r	ljb2_pp2hvar
    ljb23_pp2hvar	r	ljb23_pp2hvar
    ljb26_pp2hvar	r	ljb26_pp2hvar
    ljb26_cadd	r	ljb26_cadd
    ljb_phylop	r	ljb_phylop
    ljb2_phylop	r	ljb2_phylop
    ljb23_phylop	r	ljb23_phylop
    ljb26_phylop46way_placent	r	ljb26_phylop46way_placent
    ljb26_phylop100way_verteb	r	ljb26_phylop100way_verteb
    ljb_lrt	r	ljb_lrt
    ljb2_lrt	r	ljb2_lrt
    ljb23_lrt	r	ljb23_lrt
    ljb26_lrt	r	ljb26_lrt
    ljb_mt	r	ljb_mt
    ljb2_mt	r	ljb2_mt
    ljb23_mt	r	ljb23_mt
    ljb26_mt	r	ljb26_mt
    ljb2_ma	r	ljb2_ma
    ljb23_ma	r	ljb23_ma
    ljb26_ma	r	ljb26_ma
    ljb2_fathmm	r	ljb2_fathmm
    ljb23_fathmm	r	ljb23_fathmm
    ljb26_fathmm	r	ljb26_fathmm
    ljb2_siphy	r	ljb2_siphy
    ljb23_siphy	r	ljb23_siphy
    ljb26_siphy	r	ljb26_siphy
    ljb_gerp++	r	ljb_gerp++
    ljb2_gerp++	r	ljb2_gerp++
    ljb23_gerp++	r	ljb23_gerp++
    ljb26_gerp++	r	ljb26_gerp++
    ljb23_metasvm	r	ljb23_metasvm
    ljb26_metasvm	r	ljb26_metasvm
    ljb23_metalr	r	ljb23_metalr
    ljb26_metalr	r	ljb26_metalr
    ljb26_vest	r	ljb26_vest
    ljb_all	r	ljb_all
    ljb2_all	r	ljb2_all
    ljb23_all	r	ljb23_all
    ljb26_all	r	ljb26_all
    cg46	r	cg46
    cg69	r	cg69
    cosmic64	r	cosmic64
    cosmic65	r	cosmic65
    cosmic67	r	cosmic67
    cosmic67wgs	r	cosmic67wgs
    cosmic68	r	cosmic68
    cosmic68wgs	r	cosmic68wgs
    cosmic70	r	cosmic70
    esp5400_aa	r	esp5400_aa
    esp5400_ea	r	esp5400_ea
    esp5400_all	r	esp5400_all
    esp6500_aa	r	esp6500_aa
    esp6500_ea	r	esp6500_ea
    esp6500_all	r	esp6500_all
    esp6500si_aa	r	esp6500si_aa
    esp6500si_ea	r	esp6500si_ea
    esp6500si_all	r	esp6500si_all
    esp6500siv2_ea	r	esp6500siv2_ea
    esp6500siv2_aa	r	esp6500siv2_aa
    esp6500siv2_all	r	esp6500siv2_all
    exac01	r	exac01
    exac02	r	exac02
    1000g	r	1000g
    1000g2010	r	1000g2010
    1000g2010jul	r	1000g2010jul
    1000g2012apr	r	1000g2012apr
    1000g2010nov	r	1000g2010nov
    1000g2011may	r	1000g2011may
    1000g2012feb	r	1000g2012feb
    1000g2014aug	r	1000g2014aug
    1000g2014sep	r	1000g2014sep
    1000g2014oct	r	1000g2014oct
    snp128	r	snp128
    snp129	r	snp129
    snp130	r	snp130
    snp131	r	snp131
    snp132	r	snp132
    snp135	r	snp135
    snp137	r	snp137
    snp138	r	snp138
    snp128NonFlagged	r	snp128NonFlagged
    snp129NonFlagged	r	snp129NonFlagged
    snp130NonFlagged	r	snp130NonFlagged
    snp131NonFlagged	r	snp131NonFlagged
    snp132NonFlagged	r	snp132NonFlagged
    snp135NonFlagged	r	snp135NonFlagged
    snp137NonFlagged	r	snp137NonFlagged
    snp138NonFlagged	r	snp138NonFlagged
    nci60	r	nci60
    clinvar_20131105	r	clinvar_20131105
    clinvar_20140211	r	clinvar_20140211
    clinvar_20140303	r	clinvar_20140303
    clinvar_20140702	r	clinvar_20140702
    clinvar_20140902	r	clinvar_20140902
    clinvar_20140929	r	clinvar_20140929
    popfreq_max	r	popfreq_max
    popfreq_all	r	popfreq_all
    refGene	r	refGene
    knownGene	r	knownGene
    ensGene	r	ensGene
    gerp++elem	r	gerp++elem
    gerp++gt2	r	gerp++gt2
    caddgt20	r	caddgt20
    caddgt10	r	caddgt10
    cadd	r	cadd
_ANNOVAR_DB_
echo "<"
}
### ANNOVAR functions end...
