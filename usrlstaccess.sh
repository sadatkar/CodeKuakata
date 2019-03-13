./usrlstaccess.sh export.tsv users.ldif final.tsv
j06834> wc -l export.tsv users.ldif final.tsv
    45391 export.tsv
  3361221 users.ldif
    45391 final.tsv
	
#!/bin/bash
set -x

if [ $# -lt 3 ]
then
    echo "usage $0 usr_file oam_file out_file"
    exit
fi


gawk 'BEGIN{RS=""; FS="\n";}
     {
           currUsrId="";

       for (i=1;i<=NF;i++) {
         ##print "Field# "i" "$i;
                 if (match($i, "dn: cn=.*,cn=[Uu]sers,dc=schneider,dc=com")) {
                   split($i,usr_ary,",");
                   idStr=usr_ary[1];
                   split(idStr,id_ary,"=");
                   currUsrId=id_ary[2];
         }
         if (match($i, "oblastsuccessfullogin")) { split($i,oblst_ary,":"); oblstTm=oblst_ary[2]; print currUsrId"\t"oblstTm; }
       }
       ##print "Record#: "NR;
     }
     END {
       ##print "Total Records: "NR;
     }' $2>$2.out

gawk 'BEGIN{FS="[\t]"}
     {
       if (FNR==NR) {a[tolower($1)]=$2;next};

       usrId=tolower($1);

       {if (usrId in a)
         print $0"\t"a[usrId];
        else print $0"\tNotFound";
       }
     }' $2.out $1>$3

