#!/bin/ksh

##check paramters

if [ $# -lt 2 ]
then
    echo "usage $0 byear bmonth eyear emonth"
    exit
fi

##create date range
bday="$1-$2-01-00.00.00.00000"
eday="$3-$4-01-00.00.00.00000"
##extract data for month in question

## source db2
. /export/home/db2inst1/sqllib/db2profile
echo "connect to dp1 user $UID\nselect t1.tms_ord_id, t1.cus_ord_cd,t1.rqt_pty_id,t1.ord_cd,t1.engr_static_rt_flg,t1.sta_cd,t1.cre_dttm,t2.stp_pty_id,t2.stp_seq_num,t3.rte_cd, t2.stp_cd from op.tms_ord t1, op.tms_ord_stp t2,op.engr_sta_rte t3 where t1.cre_dttm between '$bday' and '$eday' and  t1.engr_static_rt_flg='Y' and t1.tms_ord_id = t2.tms_ord_id and t1.tms_ord_id = t3.tms_ord_id order by t1.tms_ord_id, t2.stp_seq_num with ur\nquit" | db2 >ord.tmp
echo "connect to dp1 user $UID\nselect t1.pty_id, t1.pty_nam from op.pty t1, op.pty_rol t2 where t2.rol_cd='REC' and t1.pty_id=t2.own_id with ur\nquit" | db2 >pty.tmp

## filter out data

nawk 'BEGIN{m=1;}{if(m==1){if (substr($1,1,4)=="----") {m=2;}}else if(m==2) {if ($1==""){m=3;}else{print}}}' <ord.tmp >ord.out
nawk 'BEGIN{m=1;}{if(m==1){if (substr($1,1,4)=="----") {m=2;}}else if(m==2) {if ($1==""){m=3;}else{print}}}' <pty.tmp >pty.out

## find the # of active crossdocks
nawk '{if($2=="ESRO" && $11=="CDCK") print $3, $8}'<ord.out | sort | uniq | nawk '{print $1}' | sort | uniq -c >customer.active.crossdocks

## find the # of static routes
nawk '{if ($4=="SHP" && $2=="ESRO") print $3,$10}'<ord.out | sort | uniq | nawk '{print $1}' | sort | uniq -c >customer.static.routes

## find the # of dealers
nawk 'BEGIN {while (getline<"pty.out") {pty[$1]=substr($0,index($0,".")+1);} m=1;old_id="0";}{if($1!=old_id) {old_id=$1;if($2=="ESRO"){m=2;}else{m=1;}} if (m==2){if($11=="CDCK"){m=3;}}else if (m==3){print $3,pty[$8]}}'<ord.out | sort | uniq | nawk '{print $1}' | sort | uniq -c >customer.dealers

## find the # of inbound/outbound shipments
nawk '{if ($4=="SHP") print $1,$2,$3}'<ord.out | sort | uniq | nawk '{print $3,$2}' | sort | uniq -c > customer.shipments

## find the # of orders
nawk '{if ($3 == "TO") print $1, $2;}' <ord.out | sort | uniq | nawk '{print $2;}' | sort | uniq -c > customer.orders

##done
exit

