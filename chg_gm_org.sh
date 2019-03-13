#!/usr/bin/ksh
if [[ $# -ne 2 ]]; then
    echo "Usage:  $0  <3-num org xref>  <filename>"
    exit
fi

ORG_XREF=$1
FILENAME=$2
  
nawk -v lbl=$ORG_XREF '{printf("%s%s%s\n",substr($0,1,7),lbl,substr($0,11));}' < $FILENAME > $FILENAME.new

mv $FILENAME.new $FILENAME

