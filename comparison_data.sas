/*****************************************************************************/
/* PROGRAM  : Comparison data.sas                                            */
/* AUTHOR   : Kaushik Nanduri                                                */
/* DATE     : 06-Sep-2013                                                    */
/* FUNCTION : To compare the CT4 and OC datasets                             */
/*                                                                           */
/* MODIFICATION HISTORY:                                                     */
/*                                                                           */
/* Init Date        Description                                              */
/* ==== =========== ======================================================== */
/* K.N  06-Sep-2013  Initial Version                                         */
/*                                                                           */
/*****************************************************************************/


DATA _null_;
*  set default;
   WINDOW usergroups IROW=1 ICOLUMN=1 ROWS=40 COLUMNS=200
    GROUP=WN1
     #03 @05 '********************************'
     #04 @05 '**   Input  User information  **'
     #05 @05 '********************************'
     #06 @05 'Please input'
     #08 @06 'USERID(CT4)      =>' @25 id_CT    $20.   attr=REV_VIDEO
    ;



    DISPLAY usergroups.WN1 ;
      call symput('user',   upcase(trimn(id_CT)));
          STOP ;
RUN ;

libname OC  "&user\CZOL446H/CZOL446H2337/EDC_Migration/ASP_OCRDC_data"; run;
libname CT  "&user\CZOL446H/CZOL446H2337/EDC_Migration/CT4_data"; run;


options fmtsearch=(OC CT work);

 
%let dset=aev;
data CT_&dset(DROP= STATUS ENTRYDT DB_ID CT_RECID  RPEPAG1N CODCNF1A COD1O CODUSR1A AEVNAM3A REC1N);
set CT.&dset.;
if AEVNAM1A eq '' then delete;
run;
data OC_&dset(DROP= RPEPAG1N CODCNF1A COD1O CODUSR1A AEVNAM3A REC1N);
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a  AEVNAM1A  AEVSTT1O AEVEND1O SAEREP1D;
run;
proc sort data=OC_&dset;
by sid1a  AEVNAM1A AEVSTT1O AEVEND1O SAEREP1D;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=bfs;
data CT_&dset (drop =  STATUS ENTRYDT DB_ID CT_RECID REC1N );
set CT.&dset.;
if DTAREP1C eq . then delete;
run;
data OC_&dset (drop=REC1N);
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a  ;
run;
proc sort data=OC_&dset;
by sid1a  ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=cmd;
data CT_&dset (drop =  STATUS ENTRYDT DB_ID CT_RECID RPEPAG1N COD1O  CODCNF1A CODUSR1A REC1N  CMDNAM3A );
set CT.&dset.;
if CMDCAT1C eq . then delete;
  CMDSTT1D =left(CMDSTT1D);
run;
data OC_&dset (drop =  RPEPAG1N COD1O  CODCNF1A CODUSR1A REC1N  CMDNAM3A);
set OC.&dset.;
 CMDSTT1D =left(CMDSTT1D);
run;
proc sort data=CT_&dset ;

by sid1a   CMDCTU1C  CMDDOS1A  CMDEND1D cmdnam1a    CMDRSN1A  CMDTYP1C  CMDRSN1A  CMDUNT1A CMDCAT1C;
run;
proc sort data=OC_&dset ;

by sid1a   CMDCTU1C  CMDDOS1A  CMDEND1D cmdnam1a   CMDRSN1A  CMDTYP1C  CMDRSN1A  CMDUNT1A CMDCAT1C;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;



%let dset=cmp;
data CT_&dset (drop= STATUS ENTRYDT DB_ID CT_RECID CODCNF1A COD1O CODUSR1A);
set CT.&dset.;
if SBJCMP1C EQ . THEN DELETE;
run;
data OC_&dset (drop= CODCNF1A COD1O CODUSR1A);
set OC.&dset.;
IF HLGT_TXT EQ . THEN HLGT_TXT='';
IF SOC_CODE EQ . THEN SOC_CODE='';
run;
proc sort data=CT_&dset;
by sid1a  ;
run;
proc sort data=OC_&dset;
by sid1a ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=cnd;
data CT_&dset (drop =  STATUS ENTRYDT DB_ID CT_RECID COD1O  CODCNF1A CODUSR1A REC1N HISCND3A RPEPAG1N);
set CT.&dset.;
 DGNSRG1D=LEFT(DGNSRG1D);
run;
data OC_&dset (drop= COD1O  CODCNF1A CODUSR1A REC1N HISCND3A RPEPAG1N);
set OC.&dset.;
 DGNSRG1D=LEFT(DGNSRG1D);
run;
proc sort data=CT_&dset;
by sid1a  HISCND1A  ;
run;
proc sort data=OC_&dset;
by sid1a  HISCND1A ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=com;
data CT_&dset (drop =STATUS ENTRYDT DB_ID CT_RECID RPEPAG1N rec1n RPEVIS1N);
set CT.&dset.;
IF  com1a  EQ '.' THEN  com1a ='';
com1a=left(com1a);
com1a=compress(com1a,"09"x);
run;
data OC_&dset (drop =  RPEPAG1N rec1n RPEVIS1N);
set OC.&dset.;
com1a=left(com1a);
run;
proc sort data=CT_&dset;
by sid1a vis1n pag1a com1a;
run;
proc sort data=OC_&dset;
by sid1a vis1n pag1a com1a;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=cpl;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID  RPEVIS1N  RPEPAG1N);
set CT.&dset.;
if MEDDCN2C eq . and FIRDOS1D eq '' then delete;
run;
data OC_&dset(drop=  RPEVIS1N  RPEPAG1N);
set OC.&dset.;
run;
proc sort data=CT_&dset ;
by sid1a FIRDOS1D     ;
run;
proc sort data=OC_&dset ;
by sid1a  FIRDOS1D    ;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=dar;
data CT_&dset (drop =STATUS ENTRYDT DB_ID CT_RECID RPEPAG1N  RPEVIS1N);
set CT.&dset.;
if VOLADM1N eq . then delete;
run;
data OC_&dset (drop =  RPEPAG1N  RPEVIS1N);
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a    ;
run;
proc sort data=OC_&dset;
by sid1a  ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;

%let dset=dmg;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID COU1A);
set CT.&dset.;
run;
data OC_&dset (drop=COU1A);
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a;
run;
proc sort data=OC_&dset;
by sid1a;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;



%let dset=edr;
data CT_&dset (DROP= STATUS ENTRYDT DB_ID CT_RECID  RPEVIS1N  RPEPAG1N EDRPAN1C);
set CT.&dset.;
where evlprf1c ne .; 

run;
data OC_&dset(drop=RPEVIS1N  RPEPAG1N EDRPAN1C) ;
set OC.&dset.;
run;
proc sort data=CT_&dset  ;
by sid1a  vis1n  EVLPRF1C EDRRSN1A               edrtyp1c ;
run;
proc sort data=OC_&dset;
by sid1a  vis1n EVLPRF1C EDRRSN1A              edrtyp1c ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;




%let dset=his;
data CT_&dset (DROP= STATUS ENTRYDT DB_ID CT_RECID);
set CT.&dset.;
IF  OTH1A  EQ '.' THEN  OTH1A ='';
run;
data OC_&dset;
set OC.&dset.;

run;
proc sort data=CT_&dset;
by sid1a  RHEANS1C RHETYP1C;

run;
proc sort data=OC_&dset;
by sid1a  RHEANS1C RHETYP1C;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;



%let dset=lrs2;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID PARONR1N);
set CT.&dset.;
run;
data OC_&dset (drop=PARONR1N);
set OC.&dset.;
run;
proc sort data=CT_&dset ;
by sid1a    ;
run;
proc sort data=OC_&dset ;
by sid1a    ;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=pgn;
data CT_&dset (DROP= STATUS ENTRYDT DB_ID CT_RECID RPEPAG1N RPEVIS1N);
set CT.&dset.;
if MRKEVL1C eq . then delete;

run;
data OC_&dset (DROP= RPEPAG1N RPEVIS1N);
set OC.&dset.;

run;
proc sort data=CT_&dset ;
by sid1a    ;
run;
proc sort data=OC_&dset ;
by sid1a    ;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;





%let dset=pub;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID RPEPAG1N RPEVIS1N);
set CT.&dset.;
if EVLPRF1C eq . then delete;
MNR1D=left(MNR1D);

run;
data OC_&dset(drop=RPEPAG1N RPEVIS1N);
set OC.&dset.;
MNR1D=left(MNR1D);
run;
proc sort data=CT_&dset ;
by sid1a vis1n  EVL1D ;
run;
proc sort data=OC_&dset ;
by sid1a vis1n  EVL1D;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;



%let dset=scr;
data CT_&dset (DROP= STATUS ENTRYDT DB_ID CT_RECID);
set CT.&dset.;
run;
data OC_&dset ;
set OC.&dset.;

run;
proc sort data=CT_&dset ;
by sid1a ;
run;
proc sort data=OC_&dset ;
by sid1a ;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;




%let dset=slr;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID  PARONR1N);
set CT.&dset.;
run;
data OC_&dset(drop=PARONR1N);;
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a    STM2N SMPCOL1D 
 ;
run;
proc sort data=OC_&dset;
by sid1a     STM2N SMPCOL1D 
 ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;



%let dset=vis;
data CT_&dset (DROP= STATUS ENTRYDT DB_ID CT_RECID  RPEVIS1N RPEPAG1N) ;
set CT.&dset.;
run;
data OC_&dset(DROP=RPEVIS1N RPEPAG1N) ;
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a  visnam1a vis1d   ;
run;
proc sort data=OC_&dset;
by sid1a  visnam1a vis1d  ;
run;
proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=vsn ;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID  PAG1A  RPEPAG1N  RPEVIS1N);
set CT.&dset.;
IF MRKEVL1C EQ . THEN DELETE;
run;
data OC_&dset(DROP=PAG1A RPEPAG1N  RPEVIS1N);
set OC.&dset.;
 format STM2N BEST8.3;
run;
proc sort data=CT_&dset;
by sid1a VIS1N VSN1D STM2N

    ;
run;
proc sort data=OC_&dset;
by sid1a VIS1N VSN1D STM2N

   ;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;


%let dset=wbs;
data CT_&dset (drop=STATUS ENTRYDT DB_ID CT_RECID  RPEPAG1N RPEVIS1N);
set CT.&dset.;
if EVLPRF1C eq . then delete;
run;
data OC_&dset(drop= RPEPAG1N RPEVIS1N);
set OC.&dset.;
run;
proc sort data=CT_&dset;
by sid1a  ASM1D  ;
run;
proc sort data=OC_&dset;
by sid1a  ASM1D ;
run;

proc compare base= CT_&dset compare=OC_&dset listbasevar listcompvar; 
run;




























