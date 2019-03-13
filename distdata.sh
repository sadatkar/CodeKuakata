#!/bin/ksh
set -x
##check paramters
    
if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

nawk 'BEGIN{FS="\t"}
           {
    	     curif=substr($0,34,3);
    	     curpdc=substr($0,8,3);
             if(curif=="951"&&curpdc=="076") {
	       if (maxpdc>=1131) {
                 print substr($0,1,7)"075"substr($0,11,45)"999"substr($0,59);
	       }
               else {
                 print $0;
                 maxpdc++;
               }
             }
             else {
               print $0;
             }
           }' <clean.txt>dist.txt
