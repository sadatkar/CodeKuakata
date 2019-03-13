find /opt/toolbox/tqadmin/oem/autocut -name "autocut_wrapper_events.sh.lck" -type f -mmin +10 -delete


touch -m -t '09112140' sk.txt

find /opt/toolbox/tqadmin/oem/autocut -name "autocut_wrapper_events.sh.lck" -type f -mmin +10 -delete


#!/bin/bash

LOCKDIR=/opt/toolbox/tqadmin/oem/autocut

while [[ 1  ]]; do
	now=`date '+%Y-%m-%d-%H.%M.%S.%N'`
	find $LOCKDIR -name "autocut_wrapper_events.sh.lck" -type f -mmin +10 -delete
	echo "Lock file autocut_wrapper_events.sh.lck deleted at $now: Lock file was 10 minutes older." >> /opt/toolbox/tqadmin/oem/autocut/calllog.txt 2>&1
	sleep 10m
done



nohup ./deleteOldLckFile.sh&
