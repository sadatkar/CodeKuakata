#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi



sed 's:\(.*\)\([A-Z][A-Z][A-Z]\)\(</cell>\)\(<cell/>\)\(.*\):\1\2\3<cell>\2</cell>\5:' < $1 > $1.out
