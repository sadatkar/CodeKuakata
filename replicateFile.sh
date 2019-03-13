#!/bin/bash
#set -x

if [ $# -lt 2 ]
then
    echo "usage $0 repCount baseFile"
    exit
fi

idx=0
fileNamCntr=0
filelst=`ls *.meta`

for file in $filelst
do
    while
        [ $idx -le $1 ]
        do
          (( idx++ ))
          echo idx is $idx
          newname=`echo $file|sed -e 's/.*/Public_'$idx'.meta/g'`
          echo new file name is $newname
          cp $file $newname
          sed -e 's/dDocName=RPT_PUBLIC_[0-9]*/dDocName=RPT_PUBLIC_'$idx'/' -e 's/\(FileList=Public_\)[0-9]*\(.txt,Public_\)[0-9]*\(.txt\)/\1'`expr $idx + 1`'\2'`expr $idx + 2`'\3/g' -e 's/\(DocTitleList=Public_RPT_\)[0-9]*\(,Public_RPT_\)[0-9]/\1'`expr $idx + 1`'\2'`expr $idx + 2`'/g' -e 's/xRqtId=EBS_*/xRqtId=EBS_'$idx'/' -e 's/xPrntRqtId=PRNT_EBS_*/xPrntRqtId=PRNT_EBS_'$idx'/'<$newname>$newname.sed
          mv -f $newname.sed $newname
          if [ $idx -eq 1 ]
          then
            fileNamCntr=`expr $idx + 1`
          else
            fileNamCntr=`expr $fileNamCntr + 1`
          fi
          newFNamIdx1=$fileNamCntr
          fileNamCntr=`expr $fileNamCntr + 1`
          newFNamIdx2=$fileNamCntr
          echo $fileNamCntr $newFNamIdx1 $newFNamIdx2
          newFNam1=`echo $2|sed -e 's/\([^0-9]*\)[0-9]*\(.txt\)/\1'$newFNamIdx1'\2/'`
          newFNam2=`echo $2|sed -e 's/\([^0-9]*\)[0-9]*\(.txt\)/\1'$newFNamIdx2'\2/'`
          echo $newFNam1 $newFNam2
          cp $2 $newFNam1
          cp $2 $newFNam2
        done
done
