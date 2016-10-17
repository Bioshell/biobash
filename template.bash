source ~/.bash/functions.bash
touchR(){
    if [ -z "$1" ]; then
        echo -e "Usage:"
    else
        INFILE $1
    fi
    if [ -s "${Infolder}/${InfileN}.R" ]; then
        echo -e "File exists and is not empty.."
    else
        touch ${Infolder}/${InfileN}.R
        cat > ${Infolder}/${InfileN}.R << EOI
`echo -e "#!$(which Rscript)"`
#' @title 
#' 
#' @description
#' 
#' @details
#'
#' @param
#' 
#' 
#' @return
#' 
#' @author `echo -e "$user <$EMAIL>"`
`date "+#' @date %Y-%b-%d"`
#' @examples
#' 
#' 
#' 
# --------------
# Functions:
# 
# check to see required packages, if not, try to install them.
# https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
        sapply(pkg, require, character.only =TRUE)
}
# Required packages, listed below:
packages <- c("ggplot2", "dplyr")
ipak(packages)
# --------------
# Author:
# Date:
# Modification:
# --------------

    
EOI
fi
    unset Infile Infolder InfileN
}
