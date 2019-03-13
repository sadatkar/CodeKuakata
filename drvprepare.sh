#!/bin/ksh
set -x

nawk 'BEGIN{FS="~"}
 {
	print $1","$7" "$8;	   
 }' NM_DRV>NM_DRV.out

nawk 'BEGIN{FS="~"}
 {
	print $1","$2" "$3","$4" "$5","$6","$7;	   
 }' NM_DRV_CAL>NM_DRV_CAL.out

