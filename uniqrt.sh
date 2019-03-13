#!/bin/ksh
set -x
##check paramters

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS="\t";numrif=0;rifxref="";}{
    curif=substr($0,34,3);
    currt=substr($0,29,5);
    if (rifxref!=curif) {
       if (numrif!=0) {
         print rifxref"\t"prevpdc"\t"numpdc;
       }
       rifxref=curif;
       numrif=1;
       prevpdc=currt;
       numpdc=1;
     }
     else {
       numrif++;
       if (prevpdc!=currt) {
	 print rifxref"\t"prevpdc"\t"numpdc;
	 numpdc=1;
	 prevpdc=currt;
       }
       else {
	 numpdc++;
       }
     }
   }END{print rifxref"\t"prevpdc"\t"numpdc;}' <$1>numrt.txt

##print unique RIF xref contained in this file
nawk 'BEGIN{FS="\t"}{ print substr($0,34,3)}' <$1|sort|uniq >uniqrif.txt

##print unique Origin PDC contained in this file
nawk 'BEGIN{FS="\t"}{ print substr($0,8,3)}' <$1|sort|uniq >uniqpdc.txt

##print unique routes contained in this file
nawk 'BEGIN{FS="\t"}{ print substr($0,29,5)}' <$1|sort|uniq >uniqrt.txt

##done
exit

