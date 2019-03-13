#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

grep "<GET_IMAGE" $1>arcxml.txt

nawk 'BEGIN{FS="<"}
      {
        env=$14;
        print env;
      }' <arcxml.txt>env.tmp
nawk '{if (match($1, /ENVELOPE/)) print $0;}' <env.tmp>env.txt
nawk 'BEGIN{FS="\""}
     {
       maxx=$2;
       maxy=$4;
       minx=$6;
       miny=$8;
       deltax=maxx-minx;
       deltay=maxy-miny;
       product=deltax*deltay;
       print minx","maxx","miny","maxy","deltax","deltay","product;
     }' <env.txt>product.txt
sort -t, +6 -n -r -u -osortedoutput.txt product.txt
