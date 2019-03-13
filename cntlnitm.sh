#!/bin/ksh
set -x
##check paramters

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS=","}
           {
             li=0;
             cage=$18;
             piec=$19;
             instr=$21;
             fltb=substr(instr,14,5);
             mldg=substr(instr,19,5);
             bin=substr(instr,24,5);
             pall=substr(instr,29,5);
             rack=substr(instr,44,5);
             tube=substr(instr,49,5);
             ##print "Before:"lngth;
             if (cage>0) {
               li++;
             }
             if (piec>0) {
               li++;
             }
             if (fltb>0) {
               li++;
             }
             if (mldg>0) {
               li++;
             }
             if (bin>0) {
               li++;
             }
             if (pall>0) {
               li++;
             }
             if (rack>0) {
               li++;
             }
             if (tube>0) {
               li++;
             }
             print $0","li;
           }' <$1>cnt_$1

##done
exit
