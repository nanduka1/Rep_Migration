/*****************************************************************************/
/* PROGRAM  : Blank_data.sas                                                 */
/* AUTHOR   : Kaushik Nanduri                                                */
/* DATE     : 06-Sep-2013                                                    */
/* FUNCTION : To find out the blank records in CT4 datasets                  */
/*                                                                           */
/* MODIFICATION HISTORY:                                                     */
/*                                                                           */
/* Init Date        Description                                              */
/* ==== =========== ======================================================== */
/* K.N  06-Sep-2013  Initial Version                                         */
/*                                                                           */
/*****************************************************************************/

 
options fmtsearch=(views work ct_org);
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


libname CT "&user\CZOL446H/CZOL446H2337/EDC_Migration/CT4_data";
libname BL "&user\CZOL446H/CZOL446H2337/EDC_Migration/BL"; 

data bl.aev;
set ct.aev;
if AEVNAM1A eq '' ;
run;
data bl.bfs;
set ct.bfs;
if DTAREP1C eq . ;
run;

data bl.cmd;
set ct.cmd;
if CMDCAT1C eq .;
run;

data bl.CMP;
set ct.cmp;
if SBJCMP1C EQ .;
run;
data bl.CND;
set ct.cnd;
where HISCND1A='';
run; 

data bl.COM;
set ct.com;
where COM1A='';
run; 

data bl.CPL;
set ct.cpl;
if MEDDCN2C eq . and FIRDOS1D eq '';
run; 

data bl.DAR;
set ct.dar;
if VOLADM1N eq . ;
run;

data bl.DMG;
set ct.dmg;
where DOB1D='';
run;

data bl.EDR;
set ct.edr;
if evlprf1c eq .;
run;
data bl.HIS;
set ct.his;
if rhetyp1c ='';
run;

data bl.lrs2;
set ct.lrs2;
if labcat1c eq '';
run;

data bl.pgn;
set ct.pgn;
if MRKEVL1C eq .;
run;

data bl.pub;
set ct.pub;
if EVLPRF1C eq .;
run;

data bl.SCR;
set ct.scr;
where SBJCTU1C=.;
run;


data bl.slr;
set ct.slr;
if labcat1c eq '';
run;

data bl.VIS;
set ct.vis;
if VIS1D='';
run;

data bl.vsn;
set ct.VSN;
IF MRKEVL1C EQ .;
run;

data bl.wbs;
set ct.wbs;
if EVLPRF1C eq .;
run;
