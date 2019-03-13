#!/bin/ksh
set -x

if [ $# -lt 1 ]
then
    echo "usage $0 fname"
    exit
fi

TXT_1='GET_SERVICE_INFO:'
TXT_2='AXL Parse Time:'
TXT_3='RENDERER SETUP:'
TXT_4='FEATURE LAYER:'
TXT_5='DATA SEARCH TIME:'
TXT_6='SR FEATURES PROCESSED:'
TXT_7='DATA RETRIEVAL TIME:'
TXT_8='TOTAL PROCESSING TIME:'
TXT_9='OUTPUT TIME:'
TXT_10='RESPONSE:'
TXT_11='Total Request Time:'

## filter out data

nawk '{if (match($0, /'"$TXT_1"'/)||match($0, /'"$TXT_2"'/)||match($0, /'"$TXT_3"'/)||match($0, /'"$TXT_4"'/)||match($0, /'"$TXT_5"'/)||match($0, /'"$TXT_6"'/)||match($0, /'"$TXT_7"'/)||match($0, /'"$TXT_8"'/)||match($0, /'"$TXT_9"'/)||match($0, /'"$TXT_10"'/)||match($0, /'"$TXT_11"'/)) print $0;}' <$1>>srv_tm.txt

nawk 'BEGIN{FS="]"}
      {
        data=$3;
        print data;
      }' <srv_tm.txt>data.txt


## nawk 'BEGIN{FS=":"}
##      {
##        if ($1 ~ /AXL Parse Time/) 
##        {
##          print sadat;
##        }
##        print $1","$2;
##      }' <data.txt>data.csv

nawk 'BEGIN{FS=":";cntRGN=0;cntTA=0;cntAREA=0;outFile=0}
      {
        if ($1 ~ /FEATURE LAYER/)
        {
          if ($2 ~ /.*RGN/)
          {
	    if (cntRGN == 3) 
	    {
	       outFile = 2;
    	       cntRGN = 1;
	    }
	    else
	    {
              cntRGN++;
	    }
          }
          if ($2 ~ /.*TA/)
          {
	    if (cntTA == 3) 
	    {
	       outFile = 3;
    	       cntTA = 1;
	    }
	    else
	    {
              cntTA++;
	    }
          }
          if ($2 ~ /.*AREA/)
          {
	    if (cntAREA == 3) 
	    {
	       outFile = 1;
    	       cntAREA = 1;
	    }
	    else
	    {
              cntAREA++;
	    }
          }
        }
        if ($1 ~ /Total Request Time/)
	{
	  print $1","$2>>("sni"outFile)
	}        
      }' <data.txt


## sort -t, +6 -n -r -u -osortedoutput.txt product.txt
