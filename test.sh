#!/bin/ksh

echo Frequecy>freq.txt
for num
 in 6 15 17 18 20 22 23 25 27 28 30 31
do
  ln1=$num'\t'
  ln2=`grep -c $num sort1.txt`
  echo $ln1$ln2>>freq.txt
done
