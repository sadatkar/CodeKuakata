#!/usr/bin/ksh
if [[ $# -ne 2 ]]; then
    echo "Usage:  $0  <date in Julian date yyyyddd format>  <filename>"
    exit
fi

YYYYDDD=$1
FILENAME=$2
  
nawk -v lbl=$YYYYDDD '{printf("%s%s%s\n",substr($0,1,127),lbl,substr($0,135));}' < $FILENAME > $FILENAME.new

mv $FILENAME.new $FILENAME

