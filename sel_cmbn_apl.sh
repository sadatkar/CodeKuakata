#!/usr/bin/ksh

scriptname=`basename $0`
outfile=$scriptname.out

> $outfile

### db2 options:
### +p turns off interactive prompt
### +o turns off output to screen

db2 +p <<-ISQL 

connect to dp1 user $LOGNAME using $DB2WORD

--- send report output to a file
update command options using r on $outfile 

echo 
echo ... Selecting from table ...
echo 

SELECT
H.APL_CRE_DTTM        ,                              \ 
SUBSTR(H.APL_NAM,1,10) AS APL_NAME   ,               \
H.XT_IND              ,                              \
D.APL_DTA                                            \
   FROM OP.CMBN_APL_HDR H, OP.CMBN_APL_DTL D         \
     WHERE     APL_NAM = 'ESRXDK'                          \
     AND     APL_CRE_DTTM >= '2003-04-28-09.00.00.000000'  \
     AND     APL_CRE_DTTM <= '2003-04-28-23.00.00.000000'  \
WITH UR 


quit



