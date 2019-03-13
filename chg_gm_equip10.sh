#!/usr/bin/ksh
if [[ $# -ne 2 ]]; then
    echo "Usage:  $0  <10-char equip_id>  <filename>"
    exit
fi

EQUIP_ID=$1
FILENAME=$2
  
nawk -v lbl=$EQUIP_ID '{printf("%s%s%s\n",substr($0,1,102),lbl,substr($0,113));}' < $FILENAME > $FILENAME.new

mv $FILENAME.new $FILENAME

