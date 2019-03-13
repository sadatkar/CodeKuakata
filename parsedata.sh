#!/bin/ksh
set -x
##check paramters

if [ $# -lt 4 ]
then
    echo "usage $0 day start_time end_time fname"
    exit
fi

day=$1
stime=$2
etime=$3
fname=$4

## filter out data
nawk 'BEGIN{stot=substr('$stime',1,2)*60+substr('$stime',4,2);
            etot=substr('$etime',1,2)*60+substr('$etime',4,2);
            }
            {
            t1=substr($4,1,2);
            t2=substr($4,4,2);
            t3=t1*60+t2;
            if (($3 == '$day') && (t3 >= stot) && (t3 <= etot))
              {print $0;}}' < $fname > $fname.tmp

nawk 'BEGIN{i=0; j=0; l=0; tot=0; ssec[NR]; fsec[NR];}
           {if($9 ~ /calling/){ 
             sec1=substr($4,4,2)*60+substr($4,7,2);
             ssec[i]=sec1;
             i++;}
##             print NR "\t" $4 "calling" "\t" substr($4,4,2) "\t" substr($4,7,2);}
            if($9 ~ /Success/){
             sec2=substr($4,4,2)*60+substr($4,7,2);
             fsec[j]=sec2;
             j++;}}
##             print NR "\t" $4 "Success" "\t" substr($4,4,2) "\t" substr($4,7,2);}}
       END{
           for (k in fsec){
             diff=fsec[k]-ssec[k];
             tot=tot+diff;
             l++;
             print l"\t"fsec[k]"\t"ssec[k]"\t"diff " sec";}
           print l "\t" tot"\t"tot/l;
           }'<$fname.tmp>$fname.out
##done
exit

