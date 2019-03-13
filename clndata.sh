#!/bin/ksh
set -x
##check paramters

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS="\t"}{rifxref=substr($0,34,3); if (rifxref=="902"||rifxref=="903"||rifxref=="904"||rifxref=="906"||rifxref=="907"||rifxref=="932"||rifxref=="939"||rifxref=="951") print substr($0,34,3)"\t"substr($0,8,3)"\t"$0}' <$1|sort|cut -c9- >clean.tmp


nawk 'BEGIN{FS="\t"}
	   {
	     pdc=substr($0,8,3); 
	     if(pdc=="034"||pdc=="058"||pdc=="002") {
	       print substr($0,1,7)"075"substr($0,11,45)"999"substr($0,59);
	     }
	     else if(pdc=="051"||pdc=="006"||pdc=="079") {
	       print substr($0,1,7)"076"substr($0,11,45)"999"substr($0,59);
	     }
             else {
	       print substr($0,1,55)"999"substr($0,59);
             }
	   }' <clean.tmp>clean.txt

nawk 'BEGIN{FS="\t";numrif=0;rifxref="";}{
    curif=substr($0,34,3);
    curpdc=substr($0,8,3);
    if (rifxref!=curif) {
       if (numrif!=0) {
         print rifxref"\t"prevpdc"\t"numpdc;
       }
       rifxref=curif;
       numrif=1;
       prevpdc=curpdc;
       numpdc=1;
     }
     else {
       numrif++;
       if (prevpdc!=curpdc) {
	 print rifxref"\t"prevpdc"\t"numpdc;
	 numpdc=1;
	 prevpdc=curpdc;
       }
       else {
	 numpdc++;
       }
     }
   }END{print rifxref"\t"prevpdc"\t"numpdc;}' <clean.txt>numpdc.txt

##print unique RIF xref contained in this file
nawk 'BEGIN{FS="\t"}{ print substr($0,34,3)}' <clean.txt|sort|uniq >uniqrif.txt

##print unique Origin PDC contained in this file
nawk 'BEGIN{FS="\t"}{ print substr($0,8,3)}' <clean.txt|sort|uniq >uniqpdc.txt

##done
exit

