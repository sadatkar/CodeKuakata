#!/bin/bash
set -x

if [ $# -lt 6 ]
then
    echo "usage $0 archv_fnam_ptrn out_fnam dest_rgn dlvry_dt lob exetyp"
    exit
fi

## filter out data

zegrep -c 'Order ID: |Driver ID: ' $1.gz
zegrep 'Order ID: |Driver ID: ' $1.gz>$2

egrep 'Order ID: ' $2>$2.ORD
egrep 'Destination Region: '$3 $2.ORD>$2.ORD.$3
egrep 'Delivery Date: '$4 $2.ORD.$3>$2.ORD.$3.$4
awk 'BEGIN{FS="|"}
      {
        dtls=$10;
        print dtls;
      }' <$2.ORD.$3.$4|sed 's/resulted Dimension Values:- //g'>$2.ORD.$3.$4.out
awk 'BEGIN{FS="[,:]";print "LOB,Pickup Date,Delivery Date,Execution Type,Segment Code,Origin Hub,Destination Hub,Origin Area,Destination Area,Origin Region,Destination Region,Origin BBlock,Destination BBlock,Pickup TOD,Delivery TOD,Order ID,Order Status,Shipment ID,Shipment Status,isOriginDray,isDestDray"}
      {
        gsub(/ */,"",$11);gsub(/ */,"",$13);gsub(/ */,"",$15);gsub(/ */,"",$17);gsub(/ */,"",$19);gsub(/ */,"",$21);gsub(/ */,"",$25);gsub(/ */,"",$29);gsub(/ */,"",$31);gsub(/ */,"",$33);gsub(/ */,"",$35);gsub(/ */,"",$37);gsub(/ */,"",$39);gsub(/ */,"",$41);gsub(/ */,"",$43);gsub(/ */,"",$3);gsub(/ */,"",$5);gsub(/ */,"",$7);gsub(/ */,"",$9);gsub(/ */,"",$23);gsub(/ */,"",$27);
        print $11","$13","$15","$17","$19","$21","$25","$29","$31","$33","$35","$37","$39","$41","$43","$3","$5","$7","$9","$23","$27;
      }' <$2.ORD.$3.$4.out|grep $5|grep $6|sort -t, -k16,16|uniq|sed '/ACPTD\|ASGN\|CMPL\|MVNG\|INPR\|PEND\|VLDT\|RELY/!d;'>all_$5.$6_ORD.txt

egrep 'Driver ID: ' $2>$2.DRV
sed "/ETA: $4\|ETA Date: $4/!d;" $2.DRV>$2.DRV.$4
egrep countable=true $2.DRV.$4>$2.DRV.$4.countable
egrep countable=false $2.DRV.$4>$2.DRV.$4.uncountable

egrep 'Due In Region: '$3 $2.DRV.$4>$2.DRV.$4.$3
awk 'BEGIN{FS="|"}
      {
        dtls=$10;
        print dtls;
      }' <$2.DRV.$4.$3|sed 's/resulted Dimension Values:- //g'>$2.DRV.$4.$3.cntble.inrng
awk 'BEGIN{FS="[,:]";print "LOB,ETA Date,Execution Type,Segment Code,Hub,Due In Area,Due In Region,Due In BBlock,ETA TOD,Driver ID, Status,Assigned To Load"}
      {
        gsub(/ */,"",$6);gsub(/ */,"",$8);gsub(/ */,"",$10);gsub(/ */,"",$12);gsub(/ */,"",$14);gsub(/ */,"",$16);gsub(/ */,"",$18);gsub(/ */,"",$20);gsub(/ */,"",$22);gsub(/ */,"",$2);gsub(/ */,"",$4);gsub(/ */,"",$24);
        print $6","$8","$10","$12","$14","$16","$18","$20","$22","$2","$4","$24;
      }' <$2.DRV.$4.$3.cntble.inrng|grep $5|grep $6|sort -t, -k10,10|uniq|sed '/AVAI\|BOBT\|DHNG\|STNY\|null/!d;'>all_$5.$6_DRV.txt

rm -f $2 $2.ORD $2.ORD.$3 $2.ORD.$3.$4 $2.ORD.$3.$4.out $2.DRV $2.DRV.$4 $2.DRV.$4.$3 
