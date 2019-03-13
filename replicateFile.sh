#!/bin/ksh
set -x

if [ $# -lt 2 ]
then
    echo "usage $0 metaFName replicaFName replicaCnt"
    exit
fi

## filter out data
metaFName=$1
replicaFName=$2
metaFIdxLoc=`expr index $metaFName _`
metaFIdx=`expr substr $metaFName `expr $metaFIdxLoc + 1` 1`
metaFNamPart=`expr substr $metaFName 1 $metaFIdxLoc`
metaFExtnPart=`expr substr $metaFName `expr $metaFIdxLoc + 2` `expr length $metaFName``

while
	if [ -f "idfile" ]
	then
	set -- $(awk '{ print $1 }'<"idfile"; awk '{ print $1 }'<"cntfile")
	nextid=$1
	cnt=$2
	echo $nextid","$cnt
	fi
        [ $metaFIdx -lt $3 ]
do
	metaFIdx=`expr $metaFIdx + 1`
	newMetaFName=$metaFNamPart$metaFIdx$metaFExtnPart
nawk 'BEGIN{FS=",";id='$nextid';idx='$cnt'}
      {
        previd=$1;
        id=id+5;
        idx=idx+1;
        gsub(previd,id,$0);
        print $0;
      }
	END{print id > "idfile"; print idx > "cntfile";}' <$1>>$1.out
done

