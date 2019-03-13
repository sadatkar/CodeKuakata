#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

sort -o$1.srt $1
nawk 'BEGIN{prvLn=""}
     {
       if (!match($0, prvLn)) print $0", ";
       prvLn=$0;
     }' <$1.srt>$1.out
