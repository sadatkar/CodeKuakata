#!/bin/ksh
set -x
##check paramters

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS=",";eqpcnt=1; eqpid=401;custref=48201000}
           {
             print "0"custref substr($0,10,1)"MNFST"eqpid substr($0,19,282);
             eqpcnt++;
             if (eqpcnt>12) {
               eqpcnt=0;
               eqpid++;
               custref++
             }
           }' <$1>mnfst_$1

##done
exit
