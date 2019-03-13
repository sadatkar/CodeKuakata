#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS="[ ][ ]+"}
      {
        county=$2;
        if(match(county, /\(D\)/)==0) {
          print $1","$2","$3","$4","$4$5","$6;
        }
      }' <$1>$1.csv
