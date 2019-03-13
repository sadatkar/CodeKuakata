#!/usr/bin/ksh
set -x

if [ $# -lt 3 ]
then
    echo "usage $0 fname bgnLn endLn"
    exit
fi


outfile=$1.out

awk '{if (NR>'"$2"'-1 && NR<'"$3"'+1) print $0}'<$1>$outfile
