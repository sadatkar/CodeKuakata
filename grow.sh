#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data
nextid=1000000
cnt=0

while
	if [ -f "idfile" ]
	then
	set -- $(awk '{ print $1 }'<"idfile"; awk '{ print $1 }'<"cntfile")
	nextid=$1
	cnt=$2
	echo $nextid","$cnt
	fi
        [ $cnt -lt 16996 ]
do
rm "idfile" "cntfile"
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

