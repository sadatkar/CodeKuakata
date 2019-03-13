{
   loc_id=$1;
   sqlcmd= "\"connect to dt1 user j06834 using bipu0099\n select loc.loc_id, pnt.pnt_cd, pnt.pnt_sub_cd, pnt.lat, pnt.lng from oprls.geo_pnt pnt, oprls.loc loc where loc.loc_id = '"  loc_id  "' and pnt.geo_pre_id = substr(loc.adr_geo_id, 1, 4) and pnt.geo_suf_id = substr(loc.adr_geo_id, 5) WITH UR\n quit\"" ;
   system("echo " sqlcmd " | db2");
}
