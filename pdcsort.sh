#!/bin/ksh
set -x
##check paramters

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS="\t"}
	   {
	     pdc=substr($0,8,3); 
             print pdc"\t"$0;
	   }' <$1|sort|cut -c5->final.txt

##done
exit

