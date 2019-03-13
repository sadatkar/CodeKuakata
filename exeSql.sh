#!/usr/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi


##scriptname=`basename $0`
outfile=$1.out

export DB2OPTIONS="-x +p -r$outfile +a +ec"

###nawk -F '"' -f sql.awk <$1 >$outfile
##nawk -F '"' -f sql.awk $1
nawk -F ',' -f sql.awk $1
