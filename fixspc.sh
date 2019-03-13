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
             instr=$0;
             lngth=length(instr);    
             ##print "Before:"lngth;
             if (lngth<234) {
               diff=234-lngth;
               for (i=1;i<=diff;i++) {
                 instr=instr" ";
               }
               ##print "After:"length(instr);
               print instr;
             }
           }' <$1>spc$1

##done
exit
