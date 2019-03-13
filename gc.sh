#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi


sed -n '/memory.*Tue Feb  2 05:02.*/,$p' $1|grep '^.*memory .*' >mem.out

awk 'BEGIN{FS=" "}
      {
        tm_str=$5;
        tm_milli=$13;
		tm_sec=0;
		n=split(tm_str,tm_ary,":");
		for (i=1;i<=n;i++) {
			##print i","tm_ary[i];
			if (i==1)
			{
				tm_sec = tm_sec + tm_ary[i]*60*60;
			}
			if (i==2)
			{
				tm_sec = tm_sec + tm_ary[i]*60;
			}
			if (i==3)
			{
				tm_sec = tm_sec + tm_ary[i];
			}
		}
        print tm_sec","tm_milli;
      }' <mem.out>mem.sec

awk 'BEGIN{FS=",";prevSec=0;}
      {
		sec=$1;
		milli=$2;
		if (FNR==1)
		{
			prevSec=sec;
		}
		else 
		{
			print sec-prevSec","milli;
			prevSec=sec;
		}
	  }' <mem.sec>mem.delta
