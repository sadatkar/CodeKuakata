#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

## filter out data

nawk 'BEGIN{FS=","}
      {
        init_cty=$8;
	init_st=$9;
	init_pst=$10;
	init_cntry=$11;
        tril_cty=$16;
        tril_st=$17;
        tril_pst=$18;
	tril_cntry=$19;
	str=$1":"init_cty":"tril_cty":"init_st":"tril_st":"init_pst":"tril_pst":"init_cntry":"tril_cntry;        
	if(init_cty !~ tril_cty) {
                chngStr="CITY_CHNG:";
        }
        if(init_st !~ tril_st) {
                chngStr=chngStr"ST_CHNG:";
        }
        if(init_pst !~ tril_pst) {
		chngStr=chngStr"PST_CHNG:";
        }
        if(init_cntry !~ tril_cntry) {
		chngStr=chngStr"CNTRY_CHNG:";
        }
	print chngStr":"str;
      }' <$1>$1.out
