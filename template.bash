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
# ------Meta Info------
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
# ------Functions------
# check to see required packages, if not, try to install them.
# https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
        sapply(pkg, require, character.only = TRUE)
}
# ------Load Required Packages------
packages <- c("ggplot2", "dplyr")
ipak(packages)
# ------Modification Info------
# Author:
# Date:
# Modification:
# ------Pre-Settings------
opar <- par(no.readonly = TRUE)
par()
mytheme <- theme(plot.title = element_text(face = 4,
                    size = "14", color = "brown"),
                axis.title = element_text(face = 4,
                    size = "10", color = "brown"),
                axis.text = element_text(face = "bold", size = "9",
                    color = "darkblue"),
                panel.background = element_rect(fill = "white",
                    color = "darkblue"),
                panel.grid.major.y = element_line(color = "grey", 
                    linetype = 2),
                panel.grid.major.x = element_blank(),
                legend.position = "top")
# ------Scripts Start Here------


# ------Scripts End Above This Line------
par(opar)

# ------Demo------
${InfileN}.demo <- function(){
    data(Salaries, package = "car")
    ggplot(Salaries, aes(x = rank, y = salary, fill = sex)) +
        geom_boxplot() +
        labs(title = "Salary by Rank and Sex", x = "Rank", y = "Salary") +
        mytheme
}

EOI
fi
    unset Infile Infolder InfileN
}

touchsh(){
    if [ -z "$1" ]; then
        echo -e "Usage:"
    else
        INFILE $1
    fi
    if [ -s "${Infolder}/${InfileN}.sh" ]; then
        echo -e "File exists and is not empty.."
    else
        touch ${Infolder}/${InfileN}.sh
        cat > ${Infolder}/${InfileN}.sh << EOI
`echo -e "#!$(which bash)"`
source ~/.bashrc
#' @author `echo -e "$user <$EMAIL>"`
`date "+#' @date %Y-%b-%d"`

EOI
fi
    unset Infile Infolder InfileN
}
