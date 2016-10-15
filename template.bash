touchR(){
    if [ -z "$1" ]; then
        echo -e "Usage:"
    else
        Infile=$1
        if [ "$(dirname $Infile)" = "." ]; then
            Infile=$(basename $Infile)
        fi
        Infolder=$(dirname ${Infile})
        InfileN=$(basename ${Infile}); InfileN=${InfileN%.*}
    fi
    touch ${Infolder}/${InfileN}.R
    cat > ${Infolder}/${InfileN}.R << EOI
        # Author: Zhou Shyi
        # Email: zhoushiyi25@hotmail.com
        `date "+# DATE: %Y-%b-%d"`
        # --------------
        # Author:
        # Date:
        # Modification:
        # --------------
    
EOI
    unset Infile Infolder InfileN
}
