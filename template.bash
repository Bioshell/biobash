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
    cat > ${Infolder}/${InfileN}.R <<'EOI'
    test
    test
EOI
    unset Infile Infolder InfileN
}
