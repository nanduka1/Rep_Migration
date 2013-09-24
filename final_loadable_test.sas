/*****************************************************************************/
/* PROGRAM  : Final_Loadable_Test.sas                                        */
/* AUTHOR   : Kaushik Nanduri                                                */
/* DATE     : 06-Sep-2013                                                    */
/* FUNCTION : Creates the Final loadable text file to be loaded to OC        */
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


libname ct_org "&user\CZOL446H/CZOL446H2337/EDC_Migration/CT4_data"; run;
libname views "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\views"; run;

/*CROSSED PROGRAM STARTS*/
options fmtsearch=(ct_org views work );

proc datasets lib=views kill;quit; run;
proc copy in=ct_org out=views; 
run;


proc format LIBRARY=VIEWS;
value cross 
1='Yes'
0='No';
run;

proc format LIBRARY=VIEWS;
value crossed 
0='Yes'
1='No';
run;
data views.aev;
set views.aev;

format aevctu1c aevser1c cross.;
if aevnam1a= 'NONE' then AEVNAM1A ='';

run;


data views.cmd;                                              
set views.cmd;
format cmdctu1c cross.;
if CMDNAM1A= 'NONE' then CMDNAM1A ='';
run;


data views.lrs2;
set views.lrs2;
format mrkevl1c crossed.;
run;

data views.vsn;
set views.vsn;
format mrkevl1c crossed.;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_VSN';
run;
data views.EDR;
set views.EDR;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_CENTRAL';
run;
data views.WBS;
set views.WBS;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_FAC';
run;
data views.CPL;
set views.CPL;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_COMPLAIN';
run;
data views.DAR;
set views.DAR;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_DAR';
run;
data views.pgn;
set views.pgn;
format mrkevl1c crossed.;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_PREG';
run;
data views.COM;
set views.COM;
if visnam1a='Unscheduled Visit' then visnam1a='UNS_COM';
run;



proc format library=views;
value a 
0='No action taken'
1='Study drug dose adjusted/temporarily interrupted'
2='Study drug permanently discontinued'
3='Concomitant medication taken'
4='Non-drug therapy given'
5='Hospitalization/prolonged hospitalization';
run;
data views.aev;
set views.aev;
format ACNTAK1N ACNTAK2N ACNTAK3N ACNTAK4N ACNTAK5N ACNTAK6N a.;
run;

proc format library=views;
value b
0='001 Sus Rel Study Drug'
1='002 Sus rel ster'
2='003 Sus Rel to Study Drug & Ster'
3='004 Unrel to Study Dug/Ster';
run;


data views.scr; 
set views.scr; 
visnam1a = 'Screening'; 
run;


data views.scr;
set views.scr;
if RSNNCT1N=. then RSNNCT1N=0;else RSNNCT1N=1;
if RSNNCT2N=. then RSNNCT2N=0;else RSNNCT2N=1;
if RSNNCT3N=. then RSNNCT3N=0;else RSNNCT3N=1;
if RSNNCT4N=. then RSNNCT4N=0;else RSNNCT4N=1;
if RSNNCT5N=. then RSNNCT5N=0;else RSNNCT5N=1;
if RSNNCT6N=. then RSNNCT6N=0;else RSNNCT6N=1;
if RSNNCT7N=. then RSNNCT7N=0;else RSNNCT7N=1;
if RSNNCT8N=. then RSNNCT8N=0;else RSNNCT8N=1;
if RSNNCT9N=. then RSNNCT9N=0;else RSNNCT9N=1;
format RSNNCT1N RSNNCT2N RSNNCT3N RSNNCT4N RSNNCT5N RSNNCT6N RSNNCT7N RSNNCT8N RSNNCT9N cross.;
run;

proc format library=views;   /* taken from NOVDD standards*/
value FACC31_
0='No pain'
10='Very much pain'
2='Little bit pain'
4='Little more pain'
6='Even more pain'
8='Whole lot pain';
run;

proc format library=views;  	/* taken from NOVDD standards*/
value SBJR11_
1='Spouse'
2='Parent'
3='Child'
4='Friend'
5='Sibling'
6='Volunteer'
7='Grandparent'
8='Subject'
88='Other'
10='Father'
11='Maternal grandmother'
12='Paternal grandmother'
13='Paternal grandfather'
14='Maternal grandfather'
9='Mother'
15='Biological parent'
16='Step parent'
17='Foster parent'
18='Adoptive parent'
19='Guardian'
20='Grandmother'
21='Grandfather'
22='Other relative'
23='Foster mother'
24='Foster father'
25='Patient'
26='Neonatal'
27='Fetus'
28='Both parents'
29='Other caregivers';
run;

proc format library=views;	/* taken from NOVDD standards*/
value CNTT31_
1='Site'
2='Telephone 1'
3='Telephone 2';
run;


data views.cmd; 
set views.cmd; 
if CMDSTT1D ne '' then do; 
 if substr(CMDSTT1D,3,3)='' then CMDSTT1D=left(trim('UKUK'))||''||left(trim(substr(CMDSTT1D,6))); 
else if substr(CMDSTT1D,1,2)='' then CMDSTT1D=left(trim('UK'))||left(trim(substr(CMDSTT1D,3))); 
end; 
run;

data views.cnd; 
set views.cnd; 
if  DGNSRG1D ne '' then do; 
 if substr(DGNSRG1D,3,3)='' then DGNSRG1D=left(trim('UKUK'))||''||left(trim(substr(DGNSRG1D,6))); 
else if substr(DGNSRG1D,1,2)='' then DGNSRG1D=left(trim('UK'))||left(trim(substr(DGNSRG1D,3))); 
end; 
run;

data views.pub; 
set views.pub; 
if   MNR1D ne '' then do; 
 if substr(MNR1D,3,3)='' then MNR1D=left(trim('UKUK'))||''||left(trim(substr(MNR1D,6))); 
else if substr(MNR1D,1,2)='' then MNR1D=left(trim('UK'))||left(trim(substr(MNR1D,3))); 
end; 
run;

/*CROSSED PROGRAM ENDS*/



libname views "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\views"; run;
libname sasdata "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output"; run;
libname newdata "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output";
libname tran "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output";

options ls=180 ps=40 mlogic mprint symbolgen ;

%let sortvars=patient CLI_PLAN_EVE_NAME repeat;
* gethead macro to assign vars always present;
%macro gethead(dset);
   data ct4_&dset;
    set views.&dset;
  run;
      * SORT AS YOU THINK SUITABLE  this sort is so that repeating question groups can merge; 
  proc sort data=ct4_&dset;by SID1A VISNAM1A ;run;
%mend;

/*aev*/
/*to retreive the data from CT4*/
%gethead(aev);
data aev1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep dtarep1c;
set ct4_aev;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='ADVERSE EVENTS';
dcm_name='AEV';
dcm_subset_name='AEV2';
dcm_question_grp_name='AEV';
subevent_number=0;
repeat=1;
qualifying_value='AEVG001YN_11';
study='CZOL446H2337';
rec_n=1;
dtarep1c=trim(left(put(dtarep1c,17.)));

/*converting the denormalized data to normalized format by transposing*/

proc sort data= aev1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
aev1;set aev1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=aev1 out=tran_aev1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_aev1;length dcm_subset_name $8;set tran_aev1;_NAME_=upcase(_NAME_);
data aev1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='AEV1';_name_=variable ;run;
proc sort data=aev1;by dcm_subset_name _name_;run;proc sort data=tran_aev1 out=aev1_data;by dcm_subset_name _name_;run;
data occ_aev1;set aev1_data ;by dcm_subset_name _name_;run;proc sort data=occ_aev1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_ repeat_sn ;run;
data tran.aev1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_aev1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(aev);
data aev2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep acntak1n;
keep acntak2n;
keep acntak3n;
keep acntak4n;
keep acntak5n;
keep acntak6n;
keep aevsmr1c;
keep aevctu1c;
keep aevsev1c;
keep aevser1c;
keep verbatim_meddra;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2;
keep day3;
keep month3;
keep year3;
set ct4_aev;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='ADVERSE EVENTS';
dcm_name='AEV';
dcm_subset_name='AEV2';
dcm_question_grp_name='AEVR';
subevent_number=0;
repeat=0;
qualifying_value='AEVG001YN_11';
study='CZOL446H2337';
rec_n=rec1n;
acntak1n=trim(left(put(acntak1n,19.)));
acntak2n=trim(left(put(acntak2n,32.)));
acntak3n=trim(left(put(acntak3n,32.)));
acntak4n=trim(left(put(acntak4n,32.)));
acntak5n=trim(left(put(acntak5n,26.)));
acntak6n=trim(left(put(acntak6n,32.)));
aevsmr1c=trim(left(put(aevsmr1c,13.)));
aevctu1c=trim(left(put(aevctu1c,11.)));
aevsev1c=trim(left(put(aevsev1c,12.)));
aevser1c=trim(left(put(aevser1c,11.)));
verbatim_meddra=trim(left(put(aevnam1a,70.)));
day1=substr(AEVSTT1D,1,2);
month1=substr(AEVSTT1D,3,3);
year1=substr(AEVSTT1D,6,4);
day2=substr(AEVEND1D,1,2);
month2=substr(AEVEND1D,3,3);
year2=substr(AEVEND1D,6,4);
day3=substr(SAEREP1D,1,2);
month3=substr(SAEREP1D,3,3);
year3=substr(SAEREP1D,6,4);

/*converting the denormalized data to normalized format by transposing*/

proc sort data= aev2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
aev2;set aev2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=aev2 out=tran_aev2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_aev2;length dcm_subset_name $8;set tran_aev2;_NAME_=upcase(_NAME_);
data aev2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='AEV2';_name_=variable ;run;
proc sort data=aev2;by dcm_subset_name _name_;run;proc sort data=tran_aev2 out=aev2_data;by dcm_subset_name _name_;run;
data occ_aev2;set aev2_data ;by dcm_subset_name _name_;run;proc sort data=occ_aev2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.aev2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_aev2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

 /* generating the OC loadable file*/
data load;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.aev1 tran.aev2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
  if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;
  if repeat_sn in (1,2,3,4,5,6,7,8,9,10) then subevent_number = 0;
else if repeat_sn in (11,12,13,14,15,16,17,18,19,20) then subevent_number = 0;
  else if repeat_sn in (21,22,23,24,25,26,27,28,29,30) then subevent_number = 1;
    else if repeat_sn in (31,32,33,34,35,36,37,38,39,40) then subevent_number = 2;
      else if repeat_sn in (41,42,43,44,45,46,47,48,49,50) then subevent_number = 3;
        else if repeat_sn in (51,52,53,54,55,56,57,58,59,60) then subevent_number = 4;
         else if repeat_sn in (61,62,63,64,65,66,67,68,69,70) then subevent_number = 5 ;
            else if repeat_sn in (71,72,73,74,75,76,77,78,79,80) then subevent_number = 6;
            if repeat_sn>10 then do;dci_name='ADVERSE EVENTS R';DCM_SUBSET_NAME='AEV3';QUALIFYING_VALUE='AEVG001_11';end;

%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
run;

proc sort data=load out=b;
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME;
run;
data AEV;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set b(drop=repeat_sn);
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME ;
if   first.DCM_QUESTION_NAME  then repeat_sn=1;
else repeat_sn=repeat_sn+1;;
if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if value_text='' then delete;
run;
/*aev*/


/*BFS*/

/*to retreive the data from CT4*/

%gethead(bfs);
data bfs1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep dtarep1c;
set ct4_bfs;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='ASSESSMENT FOR CLINICAL';
dcm_name='BFS';
dcm_subset_name='BFS1';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
repeat=1;
qualifying_value='BFSS001';
study='CZOL446H2337';
rec_n=1;
dtarep1c=trim(left(put(dtarep1c,17.)));

/*converting the denormalized data to normalized format by transposing*/

proc sort data= bfs1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
bfs1;set bfs1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if last.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=bfs1 out=tran_bfs1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_bfs1;length dcm_subset_name $8;set tran_bfs1;_NAME_=upcase(_NAME_);
data bfs1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='BFS1';_name_=variable ;run;
proc sort data=bfs1;by dcm_subset_name _name_;run;proc sort data=tran_bfs1 out=bfs1_data;by dcm_subset_name _name_;run;
data occ_bfs1;set bfs1_data ;by dcm_subset_name _name_;run;proc sort data=occ_bfs1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.bfs1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_bfs1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(bfs);
data bfs2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep radsnt1c;
keep frasit2c;
keep erg1c;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2;
set ct4_bfs;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='ASSESSMENT FOR CLINICAL';
dcm_name='BFS';
dcm_subset_name='BFS1';
dcm_question_grp_name='GLSTDR';
subevent_number=0;
repeat=0;
qualifying_value='BFSS001';
study='CZOL446H2337';
rec_n=rec1n;
radsnt1c=trim(left(put(radsnt1c,17.)));
frasit2c=trim(left(put(frasit2c,27.)));
erg1c=trim(left(put(erg1c,17.)));
day1=substr(FRA1D,1,2);
month1=substr(FRA1D,3,3);
year1=substr(FRA1D,6,4);
day2=substr(RAD1D,1,2);
month2=substr(RAD1D,3,3);
year2=substr(RAD1D,6,4);

/*converting the denormalized data to normalized format by transposing*/


proc sort data= bfs2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
bfs2;set bfs2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=bfs2 out=tran_bfs2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_bfs2;length dcm_subset_name $8;set tran_bfs2;_NAME_=upcase(_NAME_);
data bfs2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='BFS2';_name_=variable ;run;
proc sort data=bfs2;by dcm_subset_name _name_;run;proc sort data=tran_bfs2 out=bfs2_data;by dcm_subset_name _name_;run;
data occ_bfs2;set bfs2_data ;by dcm_subset_name _name_;run;proc sort data=occ_bfs2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.bfs2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_bfs2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

  /* generating the OC loadable file*/

data BFS;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.bfs1 tran.bfs2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
/*CLI_PLAN_EVE_NAME=upcase(CLI_PLAN_EVE_NAME);*/
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;
if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;

/*BFS*/



/*cmd*/

/*to retreive the data from CT4*/

%gethead(cmd);
data cmd1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep dtarep1c;
set ct4_cmd;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CONCOMITANT MEDICATIONS';
dcm_name='CMD';
dcm_subset_name='CMD4';
dcm_question_grp_name='CMD';
subevent_number=0;
repeat=1;
qualifying_value='CMDS001YN';
study='CZOL446H2337';
rec_n=1;
dtarep1c=trim(left(put(dtarep1c,17.)));

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cmd1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
cmd1;set cmd1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=cmd1 out=tran_cmd1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cmd1;length dcm_subset_name $8;set tran_cmd1;_NAME_=upcase(_NAME_);
data cmd1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='CMD1';_name_=variable ;run;
proc sort data=cmd1;by dcm_subset_name _name_;run;proc sort data=tran_cmd1 out=cmd1_data;by dcm_subset_name _name_;run;
data occ_cmd1;set cmd1_data ;by dcm_subset_name _name_;run;proc sort data=occ_cmd1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cmd1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cmd1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(cmd);
data cmd2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep cmdctu1c;
keep cmdunt1c;
keep cmdunt1a;
keep cmddos1a;
keep cmdfrq2c;
keep cmdfrq1a;
keep cmdrte1c;
keep meddet3c;
keep cmdtyp1c;
keep cmdrsn1a;
keep verbatim_whodrug;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2;
set ct4_cmd;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CONCOMITANT MEDICATIONS';
dcm_name='CMD';
dcm_subset_name='CMD4';
dcm_question_grp_name='CMDR';
subevent_number=0;
repeat=0;
qualifying_value='CMDS001YN';
study='CZOL446H2337';
rec_n=rec1n;
cmdctu1c=trim(left(put(cmdctu1c,11.)));
cmdunt1c=trim(left(put(cmdunt1c,19.)));
cmdfrq2c=trim(left(put(cmdfrq2c,11.)));
cmdrte1c=trim(left(put(cmdrte1c,15.)));
meddet3c=trim(left(put(meddet3c,32.)));
cmdtyp1c=trim(left(put(cmdtyp1c,32.)));
verbatim_whodrug=trim(left(put(cmdnam1a,70.)));
day1=substr(CMDSTT1D,1,2);
month1=substr(CMDSTT1D,3,3);
year1=substr(CMDSTT1D,6,4);
day2=substr(CMDEND1D,1,2);
month2=substr(CMDEND1D,3,3);
year2=substr(CMDEND1D,6,4);
where cmdnam1a ne '';

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cmd2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
cmd2;set cmd2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=cmd2 out=tran_cmd2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cmd2;length dcm_subset_name $8;set tran_cmd2;_NAME_=upcase(_NAME_);
data cmd2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='CMD2';_name_=variable ;run;
proc sort data=cmd2;by dcm_subset_name _name_;run;proc sort data=tran_cmd2 out=cmd2_data;by dcm_subset_name _name_;run;
data occ_cmd2;set cmd2_data ;by dcm_subset_name _name_;run;proc sort data=occ_cmd2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cmd2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cmd2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

   /* generating the OC loadable file*/

data load;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.cmd1 tran.cmd2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
  if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;
  if repeat_sn in (1,2,3,4,5,6,7,8,9,10) then subevent_number = 0;
else if repeat_sn in (11,12,13,14,15,16,17,18,19,20) then subevent_number = 0;
  else if repeat_sn in (21,22,23,24,25,26,27,28,29,30) then subevent_number = 1;
    else if repeat_sn in (31,32,33,34,35,36,37,38,39,40) then subevent_number = 2;
      else if repeat_sn in (41,42,43,44,45,46,47,48,49,50) then subevent_number = 3;
        else if repeat_sn in (51,52,53,54,55,56,57,58,59,60) then subevent_number = 4;
         else if repeat_sn in (61,62,63,64,65,66,67,68,69,70) then subevent_number = 5 ;
            else if repeat_sn in (71,72,73,74,75,76,77,78,79,80) then subevent_number = 6;
            if repeat_sn>10 then do;dci_name='CONCOMITANT MEDICATIONS R';DCM_SUBSET_NAME='CMD5';QUALIFYING_VALUE='CMDS001';end;

%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
run;

proc sort data=load out=b;
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME;
run;
data CMD;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set b(drop=repeat_sn);
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME ;
if   first.DCM_QUESTION_NAME  then repeat_sn=1;
else repeat_sn=repeat_sn+1;;
if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if value_text='' then delete;
run;
/*cmd*/
/*cmp*/

/*to retreive the data from CT4*/

%gethead(cmp);
data cmp1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep dcnrsn1c;
keep dcnrsn1a;
keep sbjcmp1c;
keep verbatim_meddra;
keep tmtrve1c;
keep aevne02;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2;
keep day3;
keep month3;
keep year3;
set ct4_cmp;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='STUDY COMPLETION';
dcm_name='CMP';
dcm_subset_name='CMP3';
dcm_question_grp_name='CMP';
subevent_number=0;
repeat=1;
qualifying_value='CMPG002_6';
study='CZOL446H2337';
rec_n=1;
dcnrsn1c=trim(left(put(dcnrsn1c,32.)));
sbjcmp1c=trim(left(put(sbjcmp1c,17.)));
verbatim_meddra=trim(left(put(dthcse1a,70.)));
tmtrve1c=trim(left(put(tmtrve1c,17.)));
aevne02=trim(left(put(aevman1a,20.)));
day1=substr(LSTSTR1D,1,2);
month1=substr(LSTSTR1D,3,3);
year1=substr(LSTSTR1D,6,4);
day2=substr(DTH1D,1,2);
month2=substr(DTH1D,3,3);
year2=substr(DTH1D,6,4);
day3=substr(TMTRVE1D,1,2);
month3=substr(TMTRVE1D,3,3);
year3=substr(TMTRVE1D,6,4);

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cmp1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
cmp1;set cmp1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=cmp1 out=tran_cmp1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cmp1;length dcm_subset_name $8;set tran_cmp1;_NAME_=upcase(_NAME_);
data cmp1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='CMP1';_name_=variable ;run;
proc sort data=cmp1;by dcm_subset_name _name_;run;proc sort data=tran_cmp1 out=cmp1_data;by dcm_subset_name _name_;run;
data occ_cmp1;set cmp1_data ;by dcm_subset_name _name_;run;proc sort data=occ_cmp1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cmp1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cmp1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


   /* generating the OC loadable file*/
data cmp;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.cmp1;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
/*CLI_PLAN_EVE_NAME=upcase(CLI_PLAN_EVE_NAME);*/
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*cmp*/



/*cnd*/

/*to retreive the data from CT4*/

%gethead(cnd);
data cnd1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep dtarep1c;
set ct4_cnd;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='RELEVENT MEDICAL HISTORY';
dcm_name='CND';
dcm_subset_name='CND3';
dcm_question_grp_name='CND';
subevent_number=0;
repeat=1;
qualifying_value='CNDG001YN_5';
study='CZOL446H2337';
rec_n=1;
dtarep1c=trim(left(put(dtarep1c,17.)));

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cnd1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
cnd1;set cnd1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=cnd1 out=tran_cnd1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cnd1;length dcm_subset_name $8;set tran_cnd1;_NAME_=upcase(_NAME_);
data cnd1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='CND1';_name_=variable ;run;
proc sort data=cnd1;by dcm_subset_name _name_;run;proc sort data=tran_cnd1 out=cnd1_data;by dcm_subset_name _name_;run;
data occ_cnd1;set cnd1_data ;by dcm_subset_name _name_;run;proc sort data=occ_cnd1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cnd1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cnd1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(cnd);
data cnd2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep actprb1c;
keep verbatim_meddra;
keep day;
keep month;
keep year;
set ct4_cnd;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='RELEVENT MEDICAL HISTORY';
dcm_name='CND';
dcm_subset_name='CND3';
dcm_question_grp_name='CNDR';
subevent_number=0;
repeat=0;
qualifying_value='CNDG001YN_5';
study='CZOL446H2337';
rec_n=rec1n;
actprb1c=trim(left(put(actprb1c,17.)));
verbatim_meddra=trim(left(put(hiscnd1a,70.)));
day=substr(DGNSRG1D,1,2);
month=substr(DGNSRG1D,3,3);
year=substr(DGNSRG1D,6,4);

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cnd2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
cnd2;set cnd2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=cnd2 out=tran_cnd2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cnd2;length dcm_subset_name $8;set tran_cnd2;_NAME_=upcase(_NAME_);
data cnd2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='CND2';_name_=variable ;run;
proc sort data=cnd2;by dcm_subset_name _name_;run;proc sort data=tran_cnd2 out=cnd2_data;by dcm_subset_name _name_;run;
data occ_cnd2;set cnd2_data ;by dcm_subset_name _name_;run;proc sort data=occ_cnd2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cnd2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cnd2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;



   /* generating the OC loadable file*/

data load;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.cnd1 tran.cnd2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
  if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;
  if repeat_sn in (1,2,3,4,5,6,7,8,9,10) then subevent_number = 0;
else if repeat_sn in (11,12,13,14,15,16,17,18,19,20) then subevent_number = 0;
  else if repeat_sn in (21,22,23,24,25,26,27,28,29,30) then subevent_number = 1;
    else if repeat_sn in (31,32,33,34,35,36,37,38,39,40) then subevent_number = 2;
      else if repeat_sn in (41,42,43,44,45,46,47,48,49,50) then subevent_number = 3;
        else if repeat_sn in (51,52,53,54,55,56,57,58,59,60) then subevent_number = 4;
         else if repeat_sn in (61,62,63,64,65,66,67,68,69,70) then subevent_number = 5 ;
            else if repeat_sn in (71,72,73,74,75,76,77,78,79,80) then subevent_number = 6;
            if repeat_sn>10 then do;dci_name='RELEVENT MEDICAL HISTORY R';DCM_SUBSET_NAME='CND4';QUALIFYING_VALUE='CNDG001_5';end;

%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
run;

proc sort data=load out=b;
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME;
run;
data cnd;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set b(drop=repeat_sn);
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME ;
if   first.DCM_QUESTION_NAME  then repeat_sn=1;
else repeat_sn=repeat_sn+1;;
if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if value_text='' then delete;
run;
/*cnd*/



/*com*/

/*to retreive the data from CT4*/

%gethead(com);
data com;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep pag1a;
keep rec1n;
keep com1a;
keep crf1a;
keep pag1a;
set ct4_com;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='COMMENTS';
dcm_name='COM';
dcm_subset_name='COM';
dcm_question_grp_name='GLIBSTDQG';
subevent_number=0;
qualifying_value='993';
study='CZOL446H2337';
repeat=0;
rec_n=0;
WHERE VISNAM1A NE 'UNS_COM' and com1a ne '';

/*converting the denormalized data to normalized format by transposing*/

proc sort data= com;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data com;set 
com;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                        if
 first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose data=com 
out=tran_com;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_com;length dcm_subset_name $8;set tran_com;_NAME_=upcase(_NAME_);
data com(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='COM';_name_=variable ;run;
proc sort data=com;by dcm_subset_name _name_;run;proc sort data=tran_com out=com_data;by dcm_subset_name _name_;run;
data occ_com;set com_data ;by dcm_subset_name _name_;run;proc sort data=occ_com;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.com;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_com(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(com);
data com_1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep pag1a;
keep rec1n;
keep com1a;
keep crf1a;
keep pag1a rpevis1n;
set ct4_com;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='COMMENTS_UNS';
dcm_name='COM';
dcm_subset_name='COM';
dcm_question_grp_name='GLIBSTDQG';
subevent_number=0;
qualifying_value='002';
study='CZOL446H2337';
repeat=0;
rec_n=0;
WHERE VISNAM1A eq 'UNS_COM' and com1a ne '';

/*converting the denormalized data to normalized format by transposing*/

proc sort data= com_1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n qualifying_value 
study;run;data com_1(drop=rpevis1n);set com_1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                        if
 first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=com_1 out=tran_com_1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_com_1;length dcm_subset_name $8;set tran_com_1;_NAME_=upcase(_NAME_);
data com_1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='com';_name_=variable ;run;
proc sort data=com_1;by dcm_subset_name _name_;run;proc sort data=tran_com_1 out=com_1_data;by dcm_subset_name _name_;run;
data occ_com_1;set com_1_data ;by dcm_subset_name _name_;run;proc sort data=occ_com_1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.com_1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_com_1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/
data a;
set views.com;
where visnam1a eq 'UNS_COM' and com1a ne '';
run;
data b;
set views.vis;
where visnam1a eq 'Unscheduled Visit';
run;
proc sql;
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a);
quit;

data comv;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_COM';
dci_name='COMMENTS_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='002';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';

/*converting the denormalized data to normalized format by transposing*/

proc sort data= comv;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data comv
(drop=rpevis1n) ;set comv;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=comv out=tran_comv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_comv;length dcm_subset_name $8;set tran_comv;_NAME_=upcase(_NAME_);
data comv(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='comv';_name_=variable ;run;
proc sort data=comv;by dcm_subset_name _name_;run;
proc sort data=tran_comv out=comv_data;by dcm_subset_name _name_;run;
data occ_comv;set comv_data ;by dcm_subset_name _name_;run;
proc sort data=occ_comv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.comv;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_comv(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;



   /* generating the OC loadable file*/  
data load;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.com tran.com_1 tran.comv;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;
if repeat_sn in (1,2,3,4,5,6,7,8,9,10) then subevent_number = 0; 
else if repeat_sn in (11,12,13,14,15,16,17,18,19,20) then subevent_number = 0; 
else if repeat_sn in (21,22,23,24,25,26,27,28,29,30) then subevent_number = 1; 
else if repeat_sn in (31,32,33,34,35,36,37,38,39,40) then subevent_number = 2; 

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;
run;

proc sort data=load out=b;
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME;
run;
data com;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set b(drop=repeat_sn);
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME ;
if   first.DCM_QUESTION_NAME  then repeat_sn=1;
else repeat_sn=repeat_sn+1;;
if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if value_text='' then delete;
run;
/*com*/


/*cpl*/

/*to retreive the data from CT4*/

%gethead(cpl);
data cpl1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep capret1n;
keep capdsp1n;
keep meddcn2c;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2;
set ct4_cpl;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='COMPLIANCE-VITAMIN D Y';
dcm_name='CPL';
dcm_subset_name='CPL1';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
repeat=1;
qualifying_value='CPLT004_2';
study='CZOL446H2337';
rec_n=1;
meddcn2c=trim(left(put(meddcn2c,17.)));
day1=substr(FIRDOS1D,1,2);
month1=substr(FIRDOS1D,3,3);
year1=substr(FIRDOS1D,6,4);
day2=substr(LSTDOS1D,1,2);
month2=substr(LSTDOS1D,3,3);
year2=substr(LSTDOS1D,6,4);
where visnam1a in ('Randomization','Visit 5, day 180','End of study');
run;

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cpl1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
cpl1;set cpl1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=cpl1 out=tran_cpl1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cpl1;length dcm_subset_name $8;set tran_cpl1;_NAME_=upcase(_NAME_);run;
data cpl1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='CPL1';_name_=variable ;run;
proc sort data=cpl1;by dcm_subset_name _name_;run;proc sort data=tran_cpl1 out=cpl1_data;by dcm_subset_name _name_;run;
data occ_cpl1;set cpl1_data ;by dcm_subset_name _name_;run;proc sort data=occ_cpl1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cpl1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cpl1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(cpl);
data cpl2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep capret1n;
keep capdsp1n;
keep meddcn2c;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2 rpevis1n;
set ct4_cpl;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='COMPLAINS_UNS';
dcm_name='CPL';
dcm_subset_name='CPL1';
dcm_question_grp_name='GLSTDNR';
repeat_sn=1;
qualifying_value='CPLT004_3';
study='CZOL446H2337';
rec_n=1;
meddcn2c=trim(left(put(meddcn2c,17.)));
day1=substr(FIRDOS1D,1,2);
month1=substr(FIRDOS1D,3,3);
year1=substr(FIRDOS1D,6,4);
day2=substr(LSTDOS1D,1,2);
month2=substr(LSTDOS1D,3,3);
year2=substr(LSTDOS1D,6,4);
where visnam1a eq 'UNS_COMPLAIN' and MEDDCN2C ne .;
run;

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cpl2;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n qualifying_value study;run;data cpl2
(drop=rpevis1n);set cpl2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=cpl2 out=tran_cpl2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_cpl2;length dcm_subset_name $8;set tran_cpl2;_NAME_=upcase(_NAME_);
data cpl2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='cpl2';_name_=variable ;run;
proc sort data=cpl2;by dcm_subset_name _name_;run;proc sort data=tran_cpl2 out=cpl2_data;by dcm_subset_name _name_;run;
data occ_cpl2;set cpl2_data ;by dcm_subset_name _name_;run;proc sort data=occ_cpl2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cpl2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cpl2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/***/

/*to retreive the data from CT4*/

data a;
set views.cpl;
where MEDDCN2C ne . and visnam1a eq 'UNS_COMPLAIN';;
run;
data b;
set views.vis;
where visnam1a eq 'Unscheduled Visit';
run;
proc sql;
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a);
quit;

data cplv;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_COMPLAIN';
dci_name='COMPLAINS_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='008';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';
run;

/*converting the denormalized data to normalized format by transposing*/

proc sort data= cplv;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data cplv
(drop=rpevis1n);set cplv;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=cplv out=tran_cplv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_cplv;length dcm_subset_name $8;set tran_cplv;_NAME_=upcase(_NAME_);
data cplv(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='cplv';_name_=variable ;run;
proc sort data=cplv;by dcm_subset_name _name_;run;proc sort data=tran_cplv out=cplv_data;by dcm_subset_name _name_;run;
data occ_cplv;set cplv_data ;by dcm_subset_name _name_;run;proc sort data=occ_cplv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.cplv;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_cplv(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

   /* generating the OC loadable file*/
data cpl;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.cpl1 tran.cpl2 tran.cplv;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*cpl*/
/*dar*/

/*to retreive the data from CT4*/

%gethead(dar);
data dar1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep voladm1n;
keep rsndos1c;
keep atlmed1a;
keep day;
keep month;
keep year;
keep tmmin1;
keep tmhour1;
keep tmmin2;
keep tmhour2;
set ct4_dar;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='DOSAGE ADMINISTRATION RECORD';
dcm_name='DAR';
dcm_subset_name='DAR2';
dcm_question_grp_name='DAR';
subevent_number=0;
repeat=1;
qualifying_value='DART014_4';
study='CZOL446H2337';
rec_n=1;
rsndos1c=trim(left(put(rsndos1c,32.)));
day=substr(IFS1D,1,2);
month=substr(IFS1D,3,3);
year=substr(IFS1D,6,4);
tmmin1=substr(IFSSTT1T,4,2);
tmhour1=substr(IFSSTT1T,1,2);
tmmin2=substr(IFSSTP1T,4,2);
tmhour2=substr(IFSSTP1T,1,2);
where visnam1a in ('Randomization','Visit 5, day 180');

/*converting the denormalized data to normalized format by transposing*/

proc sort data= dar1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
dar1;set dar1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=dar1 out=tran_dar1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_dar1;length dcm_subset_name $8;set tran_dar1;_NAME_=upcase(_NAME_);
data dar1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='DAR1';_name_=variable ;run;
proc sort data=dar1;by dcm_subset_name _name_;run;proc sort data=tran_dar1 out=dar1_data;by dcm_subset_name _name_;run;
data occ_dar1;set dar1_data ;by dcm_subset_name _name_;run;proc sort data=occ_dar1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.dar1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_dar1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(dar);
data dar2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep voladm1n;
keep rsndos1c;
keep atlmed1a;
keep day;
keep month;
keep year;
keep tmmin1;
keep tmhour1;
keep tmmin2;
keep tmhour2 rpevis1n;
set ct4_dar;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='DAR_UNS';
dcm_name='DAR';
dcm_subset_name='DAR2';
dcm_question_grp_name='DAR';
repeat_sn=1;
qualifying_value='DART014_4';
study='CZOL446H2337';
rec_n=1;
rsndos1c=trim(left(put(rsndos1c,32.)));
day=substr(IFS1D,1,2);
month=substr(IFS1D,3,3);
year=substr(IFS1D,6,4);
tmmin1=substr(IFSSTT1T,4,2);
tmhour1=substr(IFSSTT1T,1,2);
tmmin2=substr(IFSSTP1T,4,2);
tmhour2=substr(IFSSTP1T,1,2);
where visnam1a eq 'UNS_DAR';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= dar2;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n qualifying_value study;run;data dar2
(drop=rpevis1n);set dar2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=dar2 out=tran_dar2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_dar2;length dcm_subset_name $8;set tran_dar2;_NAME_=upcase(_NAME_);
data dar2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='dar2';_name_=variable ;run;
proc sort data=dar2;by dcm_subset_name _name_;run;proc sort data=tran_dar2 out=dar2_data;by dcm_subset_name _name_;run;
data occ_dar2;set dar2_data ;by dcm_subset_name _name_;run;proc sort data=occ_dar2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.dar2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_dar2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

data a;
set views.dar;
where VOLADM1N ne . and visnam1a eq 'UNS_DAR';
run;
data b;
set views.vis;
where visnam1a eq 'Unscheduled Visit';
run;
proc sql;
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a);
quit;

data darv;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_DAR';
dci_name='DAR_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='020';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= darv;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data darv
(drop=rpevis1n);set darv;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=darv out=tran_darv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_darv;length dcm_subset_name $8;set tran_darv;_NAME_=upcase(_NAME_);
data darv(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='darv';_name_=variable ;run;
proc sort data=darv;by dcm_subset_name _name_;run;proc sort data=tran_darv out=darv_data;by dcm_subset_name _name_;run;
data occ_darv;set darv_data ;by dcm_subset_name _name_;run;proc sort data=occ_darv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.darv;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_darv(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
  
   /* generating the OC loadable file*/

data dar;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.dar1 tran.dar2 tran.darv;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
/*CLI_PLAN_EVE_NAME=upcase(CLI_PLAN_EVE_NAME);*/
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;
if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*dar*/



/*dmg*/

/*to retreive the data from CT4*/

%gethead(dmg);
data dmg;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep sex1c;
keep eth2c;
keep ethspy1a;
keep srcref1c;
keep srcref1a;
keep rce5c;
keep sbjini1a;
keep day;
keep month;
keep year;
set ct4_dmg;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='DEMOGRAPHY';
dcm_name='DMG';
dcm_subset_name='DMG2';
dcm_question_grp_name='DMG';
subevent_number=0;
repeat=1;
qualifying_value='DMGM006_3';
study='CZOL446H2337';
rec_n=1;
sex1c=trim(left(put(sex1c,6.)));
eth2c=trim(left(put(eth2c,28.)));
srcref1c=trim(left(put(srcref1c,31.)));
rce5c=trim(left(put(rce5c,16.)));
day=substr(DOB1D,1,2);
month=substr(DOB1D,3,3);
year=substr(DOB1D,6,4);

/*converting the denormalized data to normalized format by transposing*/


proc sort data= dmg;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data dmg;set 
dmg;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=dmg out=tran_dmg;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_dmg;length dcm_subset_name $8;set tran_dmg;_NAME_=upcase(_NAME_);
data dmg(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='DMG1';_name_=variable ;run;
proc sort data=dmg;by dcm_subset_name _name_;run;proc sort data=tran_dmg out=dmg_data;by dcm_subset_name _name_;run;
data occ_dmg;set dmg_data ;by dcm_subset_name _name_;run;proc sort data=occ_dmg;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.dmg;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_dmg(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;



   /* generating the OC loadable file*/

data dmgf;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.dmg;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;


if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*dmg*/


/*edr*/

/*to retreive the data from CT4*/

%gethead(edr);
data edr1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat_sn;
keep qualifying_value;
keep study;
keep evlprf1c;
keep edrrsn1a;
keep edrtyp1c;
keep edrpan1c;
set ct4_edr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CENTRAL LAB ASSESSMENT';
dcm_name='EDRL';
dcm_subset_name='EDRL2';
dcm_question_grp_name='EDRLR';
subevent_number=0;
qualifying_value='EDRM001_5';
study='CZOL446H2337';
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a eq 'Screening' and edrtyp1c in(3,1,2,304,305,306,322,316,323);
if edrtyp1c=3 then repeat_sn=1;
if edrtyp1c=1 then repeat_sn=2;
if edrtyp1c=2 then repeat_sn=3;
if edrtyp1c=304 then repeat_sn=4;
if edrtyp1c=305 then repeat_sn=5;
if edrtyp1c=306 then repeat_sn=6;
if edrtyp1c=322 then repeat_sn=7;
if edrtyp1c=316 then repeat_sn=8;
if edrtyp1c=323 then repeat_sn=9;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= edr1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;
proc transpose data=edr1 out=tran_edr1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_edr1;length dcm_subset_name $8;set tran_edr1;_NAME_=upcase(_NAME_);
data edr1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='EDR1';_name_=variable ;run;
proc sort data=edr1;by dcm_subset_name _name_;run;proc sort data=tran_edr1 out=edr1_data;by dcm_subset_name _name_;run;
data occ_edr1;set edr1_data ;by dcm_subset_name _name_;run;proc sort data=occ_edr1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edr1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edr1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(edr);
data edr2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat_sn;
keep qualifying_value;
keep study;
keep evlprf1c;
keep edrrsn1a;
keep edrtyp1c;
keep edrpan1c;
set ct4_edr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CENTRAL LAB ASSESSMENT CP';
dcm_name='EDRL';
dcm_subset_name='EDRL3';
dcm_question_grp_name='EDRLR';
subevent_number=0;
qualifying_value='EDRM001_4';
study='CZOL446H2337';
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a eq 'Randomization' and edrtyp1c in(5);
if edrtyp1c=5 then repeat_sn=1;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= edr2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;
proc transpose data=edr2 out=tran_edr2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_edr2;length dcm_subset_name $8;set tran_edr2;_NAME_=upcase(_NAME_);
data edr2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='EDR2';_name_=variable ;run;
proc sort data=edr2;by dcm_subset_name _name_;run;proc sort data=tran_edr2 out=edr2_data;by dcm_subset_name _name_;run;
data occ_edr2;set edr2_data ;by dcm_subset_name _name_;run;proc sort data=occ_edr2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edr2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edr2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(edr);
data edr3;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat_sn;
keep qualifying_value;
keep study;
keep evlprf1c;
keep edrrsn1a;
keep edrtyp1c;
keep edrpan1c;
set ct4_edr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CENTRAL LAB- RENAL AND CALCIUM';
dcm_name='EDRL';
dcm_subset_name='EDRL4';
dcm_question_grp_name='EDRLR';
subevent_number=0;
qualifying_value='EDRM001_3';
study='CZOL446H2337';
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a in('Visit 3, day 9-11','Visit 6, day 9-11') and edrtyp1c=17;
if edrtyp1c=17 then repeat_sn=1;
run; 

/*converting the denormalized data to normalized format by transposing*/


proc sort data= edr3;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;
proc transpose data=edr3 out=tran_edr3;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_edr3;length dcm_subset_name $8;set tran_edr3;_NAME_=upcase(_NAME_);
data edr3(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='EDR3';_name_=variable ;run;
proc sort data=edr3;by dcm_subset_name _name_;run;proc sort data=tran_edr3 out=edr3_data;by dcm_subset_name _name_;run;
data occ_edr3;set edr3_data ;by dcm_subset_name _name_;run;proc sort data=occ_edr3;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edr3;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edr3(rename=(_name_=dcm_question_name col1=value_text)); 
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(edr);
data edr4;

keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat_sn;
keep qualifying_value;
keep study;
keep evlprf1c;
keep edrrsn1a;
keep edrtyp1c;
keep edrpan1c;
set ct4_edr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CENTRAL WO';
dcm_name='EDRL';
dcm_subset_name='EDRL7';
dcm_question_grp_name='EDRLR';
subevent_number=0;
qualifying_value='EDRM001_4';
study='CZOL446H2337';
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a eq 'End of study' and edrtyp1c in(3,1,2,5,304,305,306,322,323);
if edrtyp1c=3 then repeat_sn=1;
if edrtyp1c=1 then repeat_sn=2;
if edrtyp1c=2 then repeat_sn=3;
if edrtyp1c=5 then repeat_sn=4;
if edrtyp1c=304 then repeat_sn=5;
if edrtyp1c=305 then repeat_sn=6;
if edrtyp1c=306 then repeat_sn=7;
if edrtyp1c=322 then repeat_sn=8;
if edrtyp1c=323 then repeat_sn=9;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= edr4;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;
proc transpose data=edr4 out=tran_edr4;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_edr4;length dcm_subset_name $8;set tran_edr4;_NAME_=upcase(_NAME_);
data edr4(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='EDR4';_name_=variable ;run;
proc sort data=edr4;by dcm_subset_name _name_;run;proc sort data=tran_edr4 out=edr4_data;by dcm_subset_name _name_;run;
data occ_edr4;set edr4_data ;by dcm_subset_name _name_;run;proc sort data=occ_edr4;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edr4;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edr4(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

 
/*to retreive the data from CT4*/

%gethead(edr);
data edr6;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat_sn;
keep qualifying_value;
keep study;
keep evlprf1c;
keep edrrsn1a;
keep edrtyp1c;
keep edrpan1c;
set ct4_edr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CENTRAL LAB WITHOUT XRAY';
dcm_name='EDRL';
dcm_subset_name='EDRL6';
dcm_question_grp_name='EDRLR';
subevent_number=0;
qualifying_value='EDRM001_5';
study='CZOL446H2337';
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a eq 'Visit 5, day 180'  and edrtyp1c in(3,1,2,5,304,305,306);
if edrtyp1c=3 then repeat_sn=1;
if edrtyp1c=1 then repeat_sn=2;
if edrtyp1c=2 then repeat_sn=3;
if edrtyp1c=5 then repeat_sn=4;
if edrtyp1c=304 then repeat_sn=5;
if edrtyp1c=305 then repeat_sn=6;
if edrtyp1c=306 then repeat_sn=7;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= edr6;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;
proc transpose data=edr6 out=tran_edr6;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_edr6;length dcm_subset_name $8;set tran_edr6;_NAME_=upcase(_NAME_);
data edr6(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='edr6';_name_=variable ;run;
proc sort data=edr6;by dcm_subset_name _name_;run;proc sort data=tran_edr6 out=edr6_data;by dcm_subset_name _name_;run;
data occ_edr6;set edr6_data ;by dcm_subset_name _name_;run;proc sort data=occ_edr6;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edr6;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edr6(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(edr);
data edr5;

keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat_sn;
keep rpevis1n;
keep qualifying_value;
keep study;
keep evlprf1c;
keep edrrsn1a;
keep edrtyp1c;
keep edrpan1c;
set ct4_edr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='CENTRAL_UNS';
dcm_name='EDRL';
dcm_subset_name='EDRL5';
dcm_question_grp_name='EDRLR';
qualifying_value='EDRM001_5';
study='CZOL446H2337';
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a eq 'UNS_CENTRAL' and edrtyp1c in(3,1,2,17,5,304,305,306,322,316,323);
if edrtyp1c=3 then repeat_sn=1;
if edrtyp1c=1 then repeat_sn=2;
if edrtyp1c=2 then repeat_sn=3;
if edrtyp1c=17 then repeat_sn=4;
if edrtyp1c=5 then repeat_sn=5;
if edrtyp1c=304 then repeat_sn=6;
if edrtyp1c=305 then repeat_sn=7;
if edrtyp1c=306 then repeat_sn=8;
if edrtyp1c=322 then repeat_sn=9;
if edrtyp1c=316 then repeat_sn=10;
if edrtyp1c=323 then repeat_sn=11;
run;

/*converting the denormalized data to normalized format by transposing*/



proc sort data= edr5;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn rpevis1n qualifying_value study ;run;data edr5 
(drop=rpevis1n);set edr5;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn;                      
 if first.repeat_sn then Subevent_Number=-1; subevent_number+1;run;

proc sort data=edr5;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study; run;
proc transpose data=edr5 out=tran_edr5;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_edr5;length dcm_subset_name $8;set tran_edr5;_NAME_=upcase(_NAME_);
data edr5(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='edr5';_name_=variable ;run;
proc sort data=edr5;by dcm_subset_name _name_;run;proc sort data=tran_edr5 out=edr5_data;by dcm_subset_name _name_;run;

data occ_edr5;set edr5_data ;by dcm_subset_name _name_;run;proc sort data=occ_edr5;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edr5;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edr5(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

proc sql;
insert into tran.edr5 values

('0019_00005','UNS_CENTRAL',1,'CENTRAL_UNS','EDRL','EDRL5','EDRLR','EDRTYP1C',1,'URINE','EDRM001_5','CZOL446H2337');

insert into tran.edr5 values

('0019_00005','UNS_CENTRAL',1,'CENTRAL_UNS','EDRL','EDRL5','EDRLR','EDRTYP1C',2,'HEMA','EDRM001_5','CZOL446H2337');

insert into tran.edr5 values

('0019_00005','UNS_CENTRAL',1,'CENTRAL_UNS','EDRL','EDRL5','EDRLR','EDRTYP1C',3,'BIOCHEM','EDRM001_5','CZOL446H2337');

insert into tran.edr5 values

('0019_00005','UNS_CENTRAL',1,'CENTRAL_UNS','EDRL','EDRL5','EDRLR','EDRTYP1C',4,'Special lab results','EDRM001_5','CZOL446H2337');

insert into tran.edr5 values

('0019_00005','UNS_CENTRAL',1,'CENTRAL_UNS','EDRL','EDRL5','EDRLR','EDRTYP1C',5,'Bone marker','EDRM001_5','CZOL446H2337');
quit;


/***/

/*to retreive the data from CT4*/

data a; 
set views.edr; 
where EVLPRF1C ne . and visnam1a eq 'UNS_CENTRAL';; 
run; 
data b; 
set views.vis; 
where visnam1a eq 'Unscheduled Visit'; 
run; 
proc sql; 
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a); 
quit;


data edrv;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_CENTRAL';
dci_name='CENTRAL_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='005';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= edrv;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data edrv
(drop=rpevis1n);set edrv;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=edrv out=tran_edrv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_edrv;length dcm_subset_name $8;set tran_edrv;_NAME_=upcase(_NAME_);
data edrv(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='edrv';_name_=variable ;run;
proc sort data=edrv;by dcm_subset_name _name_;run;proc sort data=tran_edrv out=edrv_data;by dcm_subset_name _name_;run;
data occ_edrv;set edrv_data ;by dcm_subset_name _name_;run;proc sort data=occ_edrv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.edrv;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_edrv(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
/***/


   /* generating the OC loadable file*/


data edr;      
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;

set tran.edr1 tran.edr2 tran.edr3 tran.edr4 tran.edr6 tran.edr5 tran.edrv;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
if value_text='' then delete;
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;
run;

/*edr*/


/*his*/

/*to retreive the data from CT4*/

%gethead(his);
data his1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep oth1a;
keep ibddis1c;
keep ibdtyp1c;
keep rhedis1c;
set ct4_his;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='HISTORICAL INFORMATION';
dcm_name='HIS';
dcm_subset_name='HIS1';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
qualifying_value='HISS001';
study='CZOL446H2337';
repeat=1;
rec_n=1;
ibddis1c=trim(left(put(ibddis1c,17.)));
ibdtyp1c=trim(left(put(ibdtyp1c,18.)));
rhedis1c=trim(left(put(rhedis1c,17.)));

/*converting the denormalized data to normalized format by transposing*/


proc sort data= his1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
his1;set his1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=his1 out=tran_his1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_his1;length dcm_subset_name $8;set tran_his1;_NAME_=upcase(_NAME_);
data his1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='HIS1';_name_=variable ;run;
proc sort data=his1;by dcm_subset_name _name_;run;proc sort data=tran_his1 out=his1_data;by dcm_subset_name _name_;run;
data occ_his1;set his1_data ;by dcm_subset_name _name_;run;proc sort data=occ_his1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.his1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_his1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(his);
data his2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat_sn;
keep rheans1c;
keep rhetyp1c;
set ct4_his;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='HISTORICAL INFORMATION';
dcm_name='HIS';
dcm_subset_name='HIS1';
dcm_question_grp_name='GLSTDR';
subevent_number=0;
qualifying_value='HISS001';
study='CZOL446H2337';
rheans1c=trim(left(put(rheans1c,17.)));
rhetyp1c=trim(left(put(rhetyp1c,32.)));
if RHETYP1C=1 then repeat_sn=1;
if RHETYP1C=2 then repeat_sn=2;
if RHETYP1C=3 then repeat_sn=3;
if RHETYP1C=4 then repeat_sn=4;
if RHETYP1C=5 then repeat_sn=5;
if RHETYP1C=6 then repeat_sn=6;
if RHETYP1C=7 then repeat_sn=7;
if RHETYP1C=8 then repeat_sn=8;
if RHETYP1C=9 then repeat_sn=9;
if RHETYP1C=10 then repeat_sn=10;
if RHETYP1C=11 then repeat_sn=11;
if RHETYP1C=12 then repeat_sn=12;
if RHETYP1C=13 then repeat_sn=13;
if RHETYP1C=14 then repeat_sn=14;
if RHETYP1C=15 then repeat_sn=15;
if RHETYP1C=16 then repeat_sn=16;
if RHETYP1C=17 then repeat_sn=17;
if RHETYP1C=18 then repeat_sn=18;
if RHETYP1C=19 then repeat_sn=19;
if RHETYP1C=20 then repeat_sn=20;
if RHETYP1C=21 then repeat_sn=21;
if RHETYP1C=22 then repeat_sn=22;
run;


/*converting the denormalized data to normalized format by transposing*/


proc sort data= his2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;

proc transpose data=his2 out=tran_his2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_his2;length dcm_subset_name $8;set tran_his2;_NAME_=upcase(_NAME_);
data his2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='HIS2';_name_=variable ;run;
proc sort data=his2;by dcm_subset_name _name_;run;proc sort data=tran_his2 out=his2_data;by dcm_subset_name _name_;run;
data occ_his2;set his2_data ;by dcm_subset_name _name_;run;proc sort data=occ_his2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.his2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_his2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


   /* generating the OC loadable file*/

data his;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.his1 tran.his2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*his*/


/*lrs2*/

/*to retreive the data from CT4*/

%gethead(lrs2);
data lrs1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep mrkevl1c;
keep spr1n;
keep LABNAM1A;
keep labrsl1a;
keep day;
keep month;
keep year;
keep LABCAT1C;
keep PARNAM1C;
length LABCAT1C $30;
set ct4_lrs2;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='SERUM CREATININE';
dcm_name='LRS';
dcm_subset_name='LRS';
dcm_question_grp_name='GLIBSTDQG';
subevent_number=0;
qualifying_value='LRSM004_8';
study='CZOL446H2337';
repeat=1;
rec_n=1;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
LABCAT1C=trim(left(put(LABCAT1C,$LABC11_.)));
day=substr(SMPCOL1D,1,2);
month=substr(SMPCOL1D,3,3);
year=substr(SMPCOL1D,6,4);

/*converting the denormalized data to normalized format by transposing*/


proc sort data= lrs1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
lrs1;set lrs1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=lrs1 out=tran_lrs1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_lrs1;length dcm_subset_name $8;set tran_lrs1;_NAME_=upcase(_NAME_);
data lrs1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='LRS1';_name_=variable ;run;
proc sort data=lrs1;by dcm_subset_name _name_;run;proc sort data=tran_lrs1 out=lrs1_data;by dcm_subset_name _name_;run;
data occ_lrs1;set lrs1_data ;by dcm_subset_name _name_;run;proc sort data=occ_lrs1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.lrs1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_lrs1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;



   /* generating the OC loadable file*/

data lrs2;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.lrs1;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;


if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*lrs2*/



/*pgn*/

/*to retreive the data from CT4*/

%gethead(pgn);
data pgn1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep mrkevl1c;
keep pgnrsl1c;
keep day;
keep month;
keep year;
set ct4_pgn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='PREGNANCY TEST';
dcm_name='PGN';
dcm_subset_name='PGN2';
dcm_question_grp_name='PGN';
subevent_number=0;
qualifying_value='PGNG001_3';
study='CZOL446H2337';
repeat=1;
rec_n=1;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
pgnrsl1c=trim(left(put(pgnrsl1c,14.)));
day=substr(PGNSMP1D,1,2);
month=substr(PGNSMP1D,3,3);
year=substr(PGNSMP1D,6,4);
where visnam1a in ('Screening','Randomization','Visit 5, day 180','End of study');

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pgn1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
pgn1;set pgn1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=pgn1 out=tran_pgn1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_pgn1;length dcm_subset_name $8;set tran_pgn1;_NAME_=upcase(_NAME_);
data pgn1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='PGN1';_name_=variable ;run;
proc sort data=pgn1;by dcm_subset_name _name_;run;proc sort data=tran_pgn1 out=pgn1_data;by dcm_subset_name _name_;run;
data occ_pgn1;set pgn1_data ;by dcm_subset_name _name_;run;proc sort data=occ_pgn1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pgn1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pgn1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(pgn);
data pgn2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep qualifying_value;
keep study;
keep repeat_sn;
keep rec_n;
keep mrkevl1c;
keep pgnrsl1c;
keep day;
keep month;
keep year rpevis1n ;
set ct4_pgn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='PREGNANCY_UNS';
dcm_name='PGN';
dcm_subset_name='PGN2';
dcm_question_grp_name='PGN';
qualifying_value='PGNG001_3';
study='CZOL446H2337';
repeat_sn=1;
rec_n=1;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
pgnrsl1c=trim(left(put(pgnrsl1c,14.)));
day=substr(PGNSMP1D,1,2);
month=substr(PGNSMP1D,3,3);
year=substr(PGNSMP1D,6,4);
where visnam1a eq 'UNS_PREG' and MRKEVL1C ne .;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pgn2;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n  qualifying_value study;run;data pgn2
(drop=rpevis1n);set pgn2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;
proc transpose data=pgn2 out=tran_pgn2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_pgn2;length dcm_subset_name $8;set tran_pgn2;_NAME_=upcase(_NAME_);
data pgn2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='pgn2';_name_=variable ;run;
proc sort data=pgn2;by dcm_subset_name _name_;run;proc sort data=tran_pgn2 out=pgn2_data;by dcm_subset_name _name_;run;
data occ_pgn2;set pgn2_data ;by dcm_subset_name _name_;run;proc sort data=occ_pgn2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pgn2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pgn2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/***/

/*to retreive the data from CT4*/

data a; 
set views.pgn; 
where MRKEVL1C ne . and visnam1a eq 'UNS_PREG';; 
run; 
data b; 
set views.vis; 
where visnam1a eq 'Unscheduled Visit'; 
run; 
proc sql; 
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a); 
quit;

data pgnv;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_PREG';
dci_name='PREGNANCY_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='010';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pgnv;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data pgnv 
(drop=rpevis1n);set pgnv;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=pgnv out=tran_pgnv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_pgnv;length dcm_subset_name $8;set tran_pgnv;_NAME_=upcase(_NAME_);
data pgnv(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='pgnv';_name_=variable ;run;
proc sort data=pgnv;by dcm_subset_name _name_;run;proc sort data=tran_pgnv out=pgnv_data;by dcm_subset_name _name_;run;
data occ_pgnv;set pgnv_data ;by dcm_subset_name _name_;run;proc sort data=occ_pgnv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pgnv;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pgnv(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
/***/

   /* generating the OC loadable file*/

data pgn;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.pgn1 tran.pgn2 tran.pgnv;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*pgn*/



/*pub*/

/*to retreive the data from CT4*/

%gethead(pub);
%gethead(dmg);

proc sql;
create table pubdata as
select a.* , b.sex1c from ct4_pub a, ct4_dmg b where a.sid1a=b.sid1a;
quit;
DATA PUBDATA;
SET PUBDATA;
IF VISNAM1A='Unscheduled Visit' AND SEX1C=2 THEN VISNAM1A='UNS_PUBFEM';
ELSE IF VISNAM1A='Unscheduled Visit' AND SEX1C=1 THEN VISNAM1A='UNS_PUB';
RUN;
%gethead(pub);
data pub1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep evlprf1c;
keep brsdvl1c;
keep pubhar1c;
keep mnr1c;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2;
set pubdata;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='PUBERTAL SCALES_1';
dcm_name='PUB';
dcm_subset_name='PUB2';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
qualifying_value='PUBS001_1';
study='CZOL446H2337';
repeat=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
brsdvl1c=trim(left(put(brsdvl1c,32.)));
pubhar1c=trim(left(put(pubhar1c,32.)));
mnr1c=trim(left(put(mnr1c,17.)));
day1=substr(EVL1D,1,2);
month1=substr(EVL1D,3,3);
year1=substr(EVL1D,6,4);
day2=substr(MNR1D,1,2);
month2=substr(MNR1D,3,3);
year2=substr(MNR1D,6,4);
where visnam1a in ('Randomization','Visit 5, day 180','End of study') and SEX1C in (2);
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pub1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
pub1;set pub1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=pub1 out=tran_pub1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_pub1;length dcm_subset_name $8;set tran_pub1;_NAME_=upcase(_NAME_);
data pub1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='PUB1';_name_=variable ;run;
proc sort data=pub1;by dcm_subset_name _name_;run;proc sort data=tran_pub1 out=pub1_data;by dcm_subset_name _name_;run;
data occ_pub1;set pub1_data ;by dcm_subset_name _name_;run;proc sort data=occ_pub1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pub1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pub1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(pub);
data pub3;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep qualifying_value;
keep study;
keep repeat_sn;
keep rec_n;
keep evlprf1c;
keep brsdvl1c;
keep pubhar1c;
keep mnr1c;
keep day1;
keep month1;
keep year1;
keep day2;
keep month2;
keep year2 rpevis1n ;
set pubdata;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='PUBSCALE FEM_UNS';
dcm_name='PUB';
dcm_subset_name='PUB2';
dcm_question_grp_name='GLSTDNR';
qualifying_value='PUBS001_2';
study='CZOL446H2337';
repeat_sn=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
brsdvl1c=trim(left(put(brsdvl1c,32.)));
pubhar1c=trim(left(put(pubhar1c,32.)));
mnr1c=trim(left(put(mnr1c,17.)));
day1=substr(EVL1D,1,2);
month1=substr(EVL1D,3,3);
year1=substr(EVL1D,6,4);
day2=substr(MNR1D,1,2);
month2=substr(MNR1D,3,3);
year2=substr(MNR1D,6,4);
where visnam1a eq 'UNS_PUBFEM' and SEX1C in (2) and EVLPRF1C ne .;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pub3;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n qualifying_value study;run;data pub3
(drop=rpevis1n);set pub3;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;


proc transpose data=pub3 out=tran_pub3;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_pub3;length dcm_subset_name $8;set tran_pub3;_NAME_=upcase(_NAME_);
data pub3(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='pub3';_name_=variable ;run;
proc sort data=pub3;by dcm_subset_name _name_;run;proc sort data=tran_pub3 out=pub3_data;by dcm_subset_name _name_;run;
data occ_pub3;set pub3_data ;by dcm_subset_name _name_;run;proc sort data=occ_pub3;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pub3;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pub3(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/***/

/*to retreive the data from CT4*/

data a; 
set pubdata; 
where EVLPRF1C ne . and visnam1a eq 'UNS_PUBFEM' and SEX1C in (2);; 
run; 
data b; 
set views.vis; 
where visnam1a eq 'Unscheduled Visit'; 
run; 
proc sql; 
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a); 
quit;

data vsne1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_PUBFEM';
dci_name='PUBSCALE FEM_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='990';
study='CZOL446H2337';
rec_n=1;
day=substr(VIS1D,1,2);
month=substr(VIS1D,3,3);
year=substr(VIS1D,6,4);
where visnam1a eq 'Unscheduled Visit';
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsne1;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data vsne1 
(drop=rpevis1n);set vsne1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=vsne1 out=tran_vsne1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_vsne1;length dcm_subset_name $8;set tran_vsne1;_NAME_=upcase(_NAME_);
data vsne1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='vsne1';_name_=variable ;run;
proc sort data=vsne1;by dcm_subset_name _name_;run;proc sort data=tran_vsne1 out=vsne1_data;by dcm_subset_name _name_;run;
data occ_vsne1;set vsne1_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsne1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsne1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsne1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
/***/

/*to retreive the data from CT4*/

%gethead(pub);
data pub2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep evlprf1c;
keep pubhar2c;
keep gntstg1c;
keep day1;
keep month1;
keep year1;
set pubdata;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='PUBERTAL_SCALES_2';
dcm_name='PUB';
dcm_subset_name='PUB3';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
qualifying_value='PUBS001_2';
study='CZOL446H2337';
repeat=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
pubhar2c=trim(left(put(pubhar2c,32.)));
gntstg1c=trim(left(put(gntstg1c,32.)));
day1=substr(EVL1D,1,2);
month1=substr(EVL1D,3,3);
year1=substr(EVL1D,6,4);
where visnam1a in ('Randomization','Visit 5, day 180','End of study')and SEX1C in (1);

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pub2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
pub2;set pub2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=pub2 out=tran_pub2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_pub2;length dcm_subset_name $8;set tran_pub2;_NAME_=upcase(_NAME_);
data pub2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='PUB2';_name_=variable ;run;
proc sort data=pub2;by dcm_subset_name _name_;run;proc sort data=tran_pub2 out=pub2_data;by dcm_subset_name _name_;run;
data occ_pub2;set pub2_data ;by dcm_subset_name _name_;run;proc sort data=occ_pub2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pub2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pub2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(pub);
data pub4;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep qualifying_value;
keep study;
keep repeat_sn;
keep rec_n;
keep evlprf1c;
keep pubhar2c;
keep gntstg1c;
keep day1;
keep month1;
keep year1 rpevis1n ;
set pubdata;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='PUBSCALE_UNS';
dcm_name='PUB';
dcm_subset_name='PUB3';
dcm_question_grp_name='GLSTDNR';
qualifying_value='PUBS001';
study='CZOL446H2337';
repeat_sn=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
pubhar2c=trim(left(put(pubhar2c,32.)));
gntstg1c=trim(left(put(gntstg1c,32.)));
day1=substr(EVL1D,1,2);
month1=substr(EVL1D,3,3);
year1=substr(EVL1D,6,4);
where visnam1a eq 'UNS_PUB' and SEX1C in (1) and EVLPRF1C ne .;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= pub4;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n qualifying_value study;run;data pub4
(drop=rpevis1n);set pub4;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;
proc transpose data=pub4 out=tran_pub4;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_pub4;length dcm_subset_name $8;set tran_pub4;_NAME_=upcase(_NAME_);
data pub4(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='pub4';_name_=variable ;run;
proc sort data=pub4;by dcm_subset_name _name_;run;proc sort data=tran_pub4 out=pub4_data;by dcm_subset_name _name_;run;
data occ_pub4;set pub4_data ;by dcm_subset_name _name_;run;proc sort data=occ_pub4;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.pub4;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_pub4(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
  
/***/

/*to retreive the data from CT4*/

data a; 
set pubdata; 
where EVLPRF1C ne . and visnam1a eq 'UNS_PUB' and SEX1C in (1);; 
run; 
data b; 
set views.vis; 
where visnam1a eq 'Unscheduled Visit'; 
run; 
proc sql; 
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a); 
quit;

data vsne2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_PUB';
dci_name='PUBSCALE_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='888';
study='CZOL446H2337';
rec_n=1;
day=substr(VIS1D,1,2);
month=substr(VIS1D,3,3);
year=substr(VIS1D,6,4);
where visnam1a eq 'Unscheduled Visit';
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsne2;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data vsne2 
(drop=rpevis1n);set vsne2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=vsne2 out=tran_vsne2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_vsne2;length dcm_subset_name $8;set tran_vsne2;_NAME_=upcase(_NAME_);
data vsne2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='vsne2';_name_=variable ;run;
proc sort data=vsne2;by dcm_subset_name _name_;run;proc sort data=tran_vsne2 out=vsne2_data;by dcm_subset_name _name_;run;
data occ_vsne2;set vsne2_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsne2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsne2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsne2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
/***/

   /* generating the OC loadable file*/

data pub;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.pub1 tran.pub3 tran.vsne1 tran.pub2 tran.pub4 tran.vsne2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;
if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*pub*/


/*scr*/

/*to retreive the data from CT4*/

%gethead(scr);
data dmg1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep sbjini1a;
keep sex1c;
keep rce5c;
keep day;
keep month;
keep year;
keep  ETH2C SRCREF1C ETHSPY1A SRCREF1A;
set ct4_scr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='Screening';
dci_name='DEMOGRAPHY';
dcm_name='DMG';
dcm_subset_name='DMG2';
dcm_question_grp_name='DMG';
subevent_number=0;
repeat=1;

day=substr(DOB1D,1,2);
month=substr(DOB1D,3,3);
year=substr(DOB1D,6,4);
qualifying_value='DMGM006_3';
study='CZOL446H2337';
rec_n=1;
run;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= dmg1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
dmg1;set dmg1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do; 
if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=dmg1 out=tran_dmg1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_dmg1;length dcm_subset_name $8;set tran_dmg1;_NAME_=upcase(_NAME_);
data dmg1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='DMG';_name_=variable ;run;
proc sort data=dmg1;by dcm_subset_name _name_;run;proc sort data=tran_dmg1 out=dmg_data1;by dcm_subset_name _name_;run;
data occ_dmg1;set dmg_data1 ;by dcm_subset_name _name_;run;proc sort data=occ_dmg1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;

data tran.dmg1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_dmg1(rename=(_name_=dcm_question_name col1=value_text));
dcm_question_name = upcase(dcm_question_name);
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(scr);
data scr1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep scr_ne01;
keep rsnnct1n;
keep rsnnct2n;
keep rsnnct3n;
keep rsnnct4n;
keep rsnnct5n;
keep rsnnct6n;
keep rsnnct7n;
keep rsnnct8n;
keep rsnnct9n;
keep rsnnct1a AGE1N;
set ct4_scr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='SCREENING LOG';
dcm_name='SCR';
dcm_subset_name='SCR1';
dcm_question_grp_name='SCR';
subevent_number=0;
repeat=1;
qualifying_value='SCRG001_4';
study='CZOL446H2337';
rec_n=1;
scr_ne01=trim(left(put(sbjctu1c,yno11_.)));
rsnnct1n=trim(left(put(rsnnct1n,32.)));
rsnnct2n=trim(left(put(rsnnct2n,32.)));
rsnnct3n=trim(left(put(rsnnct3n,32.)));
rsnnct4n=trim(left(put(rsnnct4n,32.)));
rsnnct5n=trim(left(put(rsnnct5n,32.)));
rsnnct6n=trim(left(put(rsnnct6n,32.)));
rsnnct7n=trim(left(put(rsnnct7n,32.)));
rsnnct8n=trim(left(put(rsnnct8n,32.)));
rsnnct9n=trim(left(put(rsnnct9n,32.)));

/*converting the denormalized data to normalized format by transposing*/


proc sort data= scr1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
scr1;set scr1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=scr1 out=tran_scr1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_scr1;length dcm_subset_name $8;set tran_scr1;_NAME_=upcase(_NAME_);
data scr1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='SCR1';_name_=variable ;run;
proc sort data=scr1;by dcm_subset_name _name_;run;proc sort data=tran_scr1 out=scr1_data;by dcm_subset_name _name_;run;
data occ_scr1;set scr1_data ;by dcm_subset_name _name_;run;proc sort data=occ_scr1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.scr1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_scr1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/


%gethead(enroll);
data scr2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep repeat;
keep qualifying_value;
keep study;
keep rec_n;
keep SCR_NE01;
set ct4_enroll;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='Screening';
dci_name='SCREENING LOG';
dcm_name='SCR';
dcm_subset_name='SCR1';
dcm_question_grp_name='SCR';
subevent_number=0;
repeat=1;
qualifying_value='SCRG001_4';
study='CZOL446H2337';
rec_n=1;
SCR_NE01='Yes';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= scr2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
scr2;set scr2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=scr2 out=tran_scr2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_scr2;length dcm_subset_name $8;set tran_scr2;_NAME_=upcase(_NAME_);
data scr2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='SCR2';_name_=variable ;run;
proc sort data=scr2;by dcm_subset_name _name_;run;proc sort data=tran_scr2 out=scr2_data;by dcm_subset_name _name_;run;
data occ_scr2;set scr2_data ;by dcm_subset_name _name_;run;proc sort data=occ_scr2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.scr2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_scr2(rename=(_name_=dcm_question_name col1=value_text));

if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
     
   /* generating the OC loadable file*/   
data load;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.dmg1 tran.scr1 tran.scr2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
CLI_PLAN_EVE_NAME=upcase(CLI_PLAN_EVE_NAME);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;
if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;
run;

proc sort data=load out=b;
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME;
run;
data scr;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set b(drop=repeat_sn);
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME ;
if   first.DCM_QUESTION_NAME  then repeat_sn=1;
else repeat_sn=repeat_sn+1;;
if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if value_text='' then delete;
run;
/*scr*/


/*slr*/


/*to retreive the data from CT4*/

%gethead(slr);
data slr1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep evlprf1c;
keep spr1n;
keep labnam1a;
set ct4_slr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='IONIZED CALCIUM';
dcm_name='SLR';
dcm_subset_name='SLR1';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
qualifying_value='SLRS001';
study='CZOL446H2337';
repeat=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
where visnam1a eq 'Randomization';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= slr1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
slr1;set slr1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=slr1 out=tran_slr1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_slr1;length dcm_subset_name $8;set tran_slr1;_NAME_=upcase(_NAME_);
data slr1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='SLR1';_name_=variable ;run;
proc sort data=slr1;by dcm_subset_name _name_;run;proc sort data=tran_slr1 out=slr1_data;by dcm_subset_name _name_;run;
data occ_slr1;set slr1_data ;by dcm_subset_name _name_;run;proc sort data=occ_slr1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.slr1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_slr1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(slr);
data slr2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat_sn;
keep labrsl1a;
keep day;
keep month;
keep year;
keep tmmin;
keep tmhour;
keep parnam1c;
set ct4_slr;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='IONIZED CALCIUM';
dcm_name='SLR';
dcm_subset_name='SLR1';
dcm_question_grp_name='GLSTDR';
subevent_number=0;
qualifying_value='SLRS001';
study='CZOL446H2337';
day=substr(SMPCOL1D,1,2);
month=substr(SMPCOL1D,3,3);
year=substr(SMPCOL1D,6,4);
tmmin=substr(SMPCOL1T,4,2);
tmhour=substr(SMPCOL1T,1,2);
if stm2n=0 then repeat_sn=1;
else if stm2n=24 then repeat_sn=2;
else if stm2n=48 then repeat_sn=3;
where visnam1a eq 'Randomization';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= slr2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;run;
proc transpose data=slr2 out=tran_slr2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_slr2;length dcm_subset_name $8;set tran_slr2;_NAME_=upcase(_NAME_);
data slr2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='SLR2';_name_=variable ;run;
proc sort data=slr2;by dcm_subset_name _name_;run;proc sort data=tran_slr2 out=slr2_data;by dcm_subset_name _name_;run;
data occ_slr2;set slr2_data ;by dcm_subset_name _name_;run;proc sort data=occ_slr2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.slr2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_slr2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


   /* generating the OC loadable file*/

data slr;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.slr1 tran.slr2;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*slr*/



/*vis*/

/*to retreive the data from CT4*/

%gethead(vis);
data vis1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep day;
keep month;
keep year;
set ct4_vis;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='VISIT DATE';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
subevent_number=0;
qualifying_value='883';
study='CZOL446H2337';
repeat=1;
rec_n=rec1n;
day=substr(VIS1D,1,2);
month=substr(VIS1D,3,3);
year=substr(VIS1D,6,4);
where visnam1a not in('Summary','Unscheduled Visit');

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vis1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vis1;set vis1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vis1 out=tran_vis1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vis1;length dcm_subset_name $8;set tran_vis1;_NAME_=upcase(_NAME_);
data vis1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='VIS1';_name_=variable ;run;
proc sort data=vis1;by dcm_subset_name _name_;run;proc sort data=tran_vis1 out=vis1_data;by dcm_subset_name _name_;run;
data occ_vis1;set vis1_data ;by dcm_subset_name _name_;run;proc sort data=occ_vis1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vis1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vis1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


   /* generating the OC loadable file*/

data vis;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.vis1;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*vis*/



/*vsn*/

/*to retreive the data from CT4*/

%gethead(vsn);
data vsn1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep hgt1n;
keep wgt1n;
keep btp1n;
keep stnpls1n;
keep stnsbp1n;
keep stndbp1n;
keep mrkevl1c;
keep stnhgt1n;
keep stnhgt1c;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep STM2N;
keep STMUNT1A;
keep day1;
keep month1;
keep year1;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='VITAL SIGNS_W';
dcm_name='VSN';
dcm_subset_name='VSN2';
dcm_question_grp_name='VSNR';
subevent_number=0;
qualifying_value='VSNS001_2';
study='CZOL446H2337';
repeat=0;
rec_n=rec1n;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
stnhgt1c=trim(left(put(stnhgt1c,2.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
where visnam1a = 'Randomization' and STM2N=0;

/*converting the denormalized data to normalized format by transposing*/

proc sort data= vsn1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vsn1;set vsn1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vsn1 out=tran_vsn1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vsn1;length dcm_subset_name $8;set tran_vsn1;_NAME_=upcase(_NAME_);
data vsn1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='VSN1';_name_=variable ;run;
proc sort data=vsn1;by dcm_subset_name _name_;run;proc sort data=tran_vsn1 out=vsn1_data;by dcm_subset_name _name_;run;
data occ_vsn1;set vsn1_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(vsn);
data vsn2;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep btp1n;
keep mrkevl1c;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep STM2N;
keep STMUNT1A;
keep day1;
keep month1;
keep year1;
keep tmhour;
keep tmmin;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='BODY TEMPERATURE';
dcm_name='VSN';
dcm_subset_name='VSN3';
dcm_question_grp_name='VSNR';
subevent_number=0;
qualifying_value='VSNM004_5';
study='CZOL446H2337';
repeat=0;
rec_n=rec1n;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
tmhour=substr(VSN1T,1,2);
tmmin=substr(VSN1T,4,2);
where visnam1a = 'Randomization' and STM2N=24;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsn2;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vsn2;set vsn2;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vsn2 out=tran_vsn2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vsn2;length dcm_subset_name $8;set tran_vsn2;_NAME_=upcase(_NAME_);
data vsn2(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='VSN2';_name_=variable ;run;
proc sort data=vsn2;by dcm_subset_name _name_;run;proc sort data=tran_vsn2 out=vsn2_data;by dcm_subset_name _name_;run;
data occ_vsn2;set vsn2_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn2;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn2(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/

%gethead(vsn);
data vsn3;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep mrkevl1c;
keep hgt1n;
keep wgt1n;
keep stnsbp1n;
keep stndbp1n;
keep stnpls1n;
keep stnhgt1n;
keep stnhgt1c;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep day1;
keep month1;
keep year1;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='VITAL SIGNS';
dcm_name='VSN';
dcm_subset_name='VSN4';
dcm_question_grp_name='VSNR';
subevent_number=0;
qualifying_value='VSNS001';
study='CZOL446H2337';
repeat=0;
rec_n=rec1n;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
stnhgt1c=trim(left(put(stnhgt1c,2.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
where visnam1a in('End of study');

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsn3;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vsn3;set vsn3;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vsn3 out=tran_vsn3;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vsn3;length dcm_subset_name $8;set tran_vsn3;_NAME_=upcase(_NAME_);
data vsn3(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='VSN3';_name_=variable ;run;
proc sort data=vsn3;by dcm_subset_name _name_;run;proc sort data=tran_vsn3 out=vsn3_data;by dcm_subset_name _name_;run;
data occ_vsn3;set vsn3_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn3;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn3;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn3(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/*to retreive the data from CT4*/

%gethead(vsn);
data vsn3_5;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep mrkevl1c;
keep hgt1n;
keep wgt1n;
keep stnsbp1n;
keep stndbp1n;
keep stnpls1n;
keep stnhgt1n;
keep stnhgt1c;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep day1;
keep month1;
keep year1;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='VITAL SIGNS_4';
dcm_name='VSN';
dcm_subset_name='VSN7';
dcm_question_grp_name='VSNR';
subevent_number=0;
qualifying_value='VSNM004_6';
study='CZOL446H2337';
repeat=0;
rec_n=rec1n;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
stnhgt1c=trim(left(put(stnhgt1c,2.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
where visnam1a in('Visit 5, day 180');

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsn3_5;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vsn3_5;set vsn3_5;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vsn3_5 out=tran_vsn3_5;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vsn3_5;length dcm_subset_name $8;set tran_vsn3_5;_NAME_=upcase(_NAME_);
data vsn3_5(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='vsn3_5';_name_=variable ;run;
proc sort data=vsn3_5;by dcm_subset_name _name_;run;proc sort data=tran_vsn3_5 out=vsn3_5_data;by dcm_subset_name _name_;run;
data occ_vsn3_5;set vsn3_5_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn3_5;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn3_5;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn3_5(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;



/**/

/*to retreive the data from CT4*/

%gethead(vsn);
data vsn3_1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat_sn;

keep mrkevl1c;
keep hgt1n;
keep wgt1n;
keep stnsbp1n;
keep stndbp1n;
keep stnpls1n;
keep stnhgt1n;
keep stnhgt1c;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep day1;
keep month1;
keep year1 rpevis1n ;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='VITAL SIGNS_UNS';
dcm_name='VSN';
dcm_subset_name='VSN4';
dcm_question_grp_name='VSNR';
qualifying_value='VSNS001';
study='CZOL446H2337';
repeat_sn=1;

mrkevl1c=trim(left(put(mrkevl1c,11.)));
stnhgt1c=trim(left(put(stnhgt1c,2.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
where visnam1a eq 'UNS_VSN' and mrkevl1c ne .;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsn3_1;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn rpevis1n qualifying_value study;run;data vsn3_1
(drop=rpevis1n);set vsn3_1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=vsn3_1 out=tran_vsn3_1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;

data tran_vsn3_1;length dcm_subset_name $8;set tran_vsn3_1;_NAME_=upcase(_NAME_);
data vsn3_1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='vsn3_1';_name_=variable ;run;
proc sort data=vsn3_1;by dcm_subset_name _name_;run;proc sort data=tran_vsn3_1 out=vsn3_1_data;by dcm_subset_name _name_;run;
data occ_vsn3_1;set vsn3_1_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn3_1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn3_1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn3_1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;
/**/
/***/

/*to retreive the data from CT4*/

data a; 
set views.vsn; 
where MRKEVL1C ne . and visnam1a eq 'UNS_VSN';; 
run; 
data b; 
set views.vis; 
where visnam1a eq 'Unscheduled Visit'; 
run; 
proc sql; 
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a); 
quit;
data vsv;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_VSN';
dci_name='VITAL SIGNS_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='001';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsv;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data vsv
(drop=rpevis1n);set vsv;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=vsv out=tran_vsv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_vsv;length dcm_subset_name $8;set tran_vsv;_NAME_=upcase(_NAME_);
data vsv(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='vsv';_name_=variable ;run;
proc sort data=vsv;by dcm_subset_name _name_;run;proc sort data=tran_vsv out=vsv_data;by dcm_subset_name _name_;run;
data occ_vsv;set vsv_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsv;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsv;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsv(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


/***/

/*to retreive the data from CT4*/

%gethead(vsn);
data vsn4;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep mrkevl1c;
keep wgt1n;
keep stnsbp1n;
keep stndbp1n;
keep stnpls1n;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep day1;
keep month1;
keep year1;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='VITAL SIGNS_S';
dcm_name='VSN';
dcm_subset_name='VSN5';
dcm_question_grp_name='VSNR';
subevent_number=0;
qualifying_value='VSNS001_1';
study='CZOL446H2337';
repeat=0;
rec_n=rec1n;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
where visnam1a eq 'Screening';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsn4;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vsn4;set vsn4;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vsn4 out=tran_vsn4;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vsn4;length dcm_subset_name $8;set tran_vsn4;_NAME_=upcase(_NAME_);
data vsn4(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='VSN4';_name_=variable ;run;
proc sort data=vsn4;by dcm_subset_name _name_;run;proc sort data=tran_vsn4 out=vsn4_data;by dcm_subset_name _name_;run;
data occ_vsn4;set vsn4_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn4;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn4;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn4(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/*to retreive the data from CT4*/


%gethead(vsn);
data vsn5;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep btp1n;
keep mrkevl1c;
keep WGTUNT1C;
keep HGTUNT1C;
keep BTPUNT1C;
keep STM2N;
keep STMUNT1A;
keep day1;
keep month1;
keep year1;
keep tmhour;
keep tmmin;
set ct4_vsn;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='BODY TEMPERATURE 48H';
dcm_name='VSN';
dcm_subset_name='VSN6';
dcm_question_grp_name='VSNR';
subevent_number=0;
qualifying_value='VSNM004_6';
study='CZOL446H2337';
repeat=0;
rec_n=rec1n;
mrkevl1c=trim(left(put(mrkevl1c,11.)));
day1=substr(VSN1D,1,2);
month1=substr(VSN1D,3,3);
year1=substr(VSN1D,6,4);
tmhour=substr(VSN1T,1,2);
tmmin=substr(VSN1T,4,2);
where visnam1a eq 'Randomization' AND STM2N=48;

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsn5;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
vsn5;set vsn5;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=vsn5 out=tran_vsn5;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_vsn5;length dcm_subset_name $8;set tran_vsn5;_NAME_=upcase(_NAME_);
data vsn5(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='VSN5';_name_=variable ;run;
proc sort data=vsn5;by dcm_subset_name _name_;run;proc sort data=tran_vsn5 out=vsn5_data;by dcm_subset_name _name_;run;
data occ_vsn5;set vsn5_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsn5;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsn5;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsn5(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;


   /* generating the OC loadable file*/


data load;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.vsn1 tran.vsn2 tran.vsn3 tran.vsn3_5 tran.vsn3_1 tran.vsv tran.vsn4 tran.vsn5;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;

proc sort data=load out=b;
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME;
run;
data vsn;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set b(drop=repeat_sn);
by patient CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME ;
if   first.DCM_QUESTION_NAME  then repeat_sn=1;
else repeat_sn=repeat_sn+1;;

if DCM_QUESTION_NAME='STM2N' then DCM_QUE_OCC_SN=2;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if value_text='' then delete;
run;
/*vsn*/



/*wbs*/

/*to retreive the data from CT4*/

%gethead(wbs);
data wbs1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep subevent_number;
keep qualifying_value;
keep study;
keep repeat;
keep rec_n;
keep evlprf1c;
keep evldne1c;
keep facchs4c;
keep evlpai1c;
keep day;
keep month;
keep year;
set ct4_wbs;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='FACES PAIN SCALE';
dcm_name='WBS';
dcm_subset_name='WBS2';
dcm_question_grp_name='GLSTDNR';
subevent_number=0;
qualifying_value='WBSS001';
study='CZOL446H2337';
repeat=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
evldne1c=trim(left(put(evldne1c,32.)));
facchs4c=trim(left(put(facchs4c,16.)));
evlpai1c=trim(left(put(evlpai1c,30.)));
day=substr(ASM1D,1,2);
month=substr(ASM1D,3,3);
year=substr(ASM1D,6,4);
where visnam1a in ('Randomization','Visit 4, day 90, T','Visit 5, day 180','Visit 7, day 270, T','End of study');

/*converting the denormalized data to normalized format by transposing*/


proc sort data= wbs1;by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study;run;data 
wbs1;set wbs1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;if repeat=0 then do;                       
 if first.patient and first.CLI_PLAN_EVE_NAME then repeat_sn=0;repeat_sn+1;end;if repeat=1 then do;repeat_sn=1;if first.CLI_PLAN_EVE_NAME;end;run;proc transpose 
data=wbs1 out=tran_wbs1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_wbs1;length dcm_subset_name $8;set tran_wbs1;_NAME_=upcase(_NAME_);
data wbs1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='WBS1';_name_=variable ;run;
proc sort data=wbs1;by dcm_subset_name _name_;run;proc sort data=tran_wbs1 out=wbs1_data;by dcm_subset_name _name_;run;
data occ_wbs1;set wbs1_data ;by dcm_subset_name _name_;run;proc sort data=occ_wbs1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.wbs1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_wbs1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/**/

/*to retreive the data from CT4*/

%gethead(wbs);
data wbs1_1;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep qualifying_value;
keep study;
keep repeat_sn;
keep rec_n;
keep evlprf1c;
keep evldne1c;
keep facchs4c;
keep evlpai1c;
keep day;
keep month;
keep year rpevis1n ;
set ct4_wbs;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name=trim(left(put(visnam1a,20.)));
dci_name='FACES_UNS';
dcm_name='WBS';
dcm_subset_name='WBS2';
dcm_question_grp_name='GLSTDNR';
qualifying_value='WBSS001';
study='CZOL446H2337';
repeat_sn=1;
rec_n=1;
evlprf1c=trim(left(put(evlprf1c,17.)));
evldne1c=trim(left(put(evldne1c,32.)));
facchs4c=trim(left(put(facchs4c,16.)));
evlpai1c=trim(left(put(evlpai1c,30.)));
day=substr(ASM1D,1,2);
month=substr(ASM1D,3,3);
year=substr(ASM1D,6,4);
where visnam1a eq 'UNS_FAC';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= wbs1_1;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n qualifying_value study rpevis1n;run;data wbs1_1
(drop=rpevis1n);set wbs1_1;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=wbs1_1 out=tran_wbs1_1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;data 
tran_wbs1_1;length dcm_subset_name $8;set tran_wbs1_1;_NAME_=upcase(_NAME_);
data wbs1_1(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='wbs1_1';_name_=variable ;run;
proc sort data=wbs1_1;by dcm_subset_name _name_;run;proc sort data=tran_wbs1_1 out=wbs1_1_data;by dcm_subset_name _name_;run;
data occ_wbs1_1;set wbs1_1_data ;by dcm_subset_name _name_;run;proc sort data=occ_wbs1_1;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.wbs1_1;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_wbs1_1(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/**/
/***/

/*to retreive the data from CT4*/

data a; 
set views.wbs; 
where EVLPRF1C ne . and visnam1a eq 'UNS_FAC';
run; 
data b; 
set views.vis; 
where visnam1a eq 'Unscheduled Visit'; 
run; 
proc sql; 
create table c as select * from b b where exists (select * from a where b.rpevis1n=a.rpevis1n and a.sid1a=b.sid1a); 
quit;
data vsnewb;
keep patient;
keep cli_plan_eve_name;
keep dci_name;
keep dcm_name;
keep dcm_subset_name;
keep dcm_question_grp_name;
keep repeat_sn;
keep qualifying_value;
keep study;
keep rec_n;
keep day;
keep month;
keep year rpevis1n;
set c;
patient=trim(left(put(sid1a,10.)));
cli_plan_eve_name='UNS_FAC';
dci_name='FACES_UNS';
dcm_name='VIS';
dcm_subset_name='VIS2';
dcm_question_grp_name='VIS';
repeat_sn=1;
qualifying_value='999';
study='CZOL446H2337';
rec_n=1;
day=substr(vis1D,1,2);
month=substr(vis1D,3,3);
year=substr(vis1D,6,4);
where visnam1a eq 'Unscheduled Visit';

/*converting the denormalized data to normalized format by transposing*/


proc sort data= vsnewb;by patient CLI_PLAN_EVE_NAME  DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name rec_n rpevis1n qualifying_value study;run;data vsnewb
(drop=rpevis1n);set vsnewb;by patient CLI_PLAN_EVE_NAME DCI_NAME ;                      
 if first.CLI_PLAN_EVE_NAME then Subevent_Number=-1; subevent_number+1;run;

proc transpose data=vsnewb out=tran_vsnewb;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name repeat_sn qualifying_value study;var _all_;run;
data tran_vsnewb;length dcm_subset_name $8;set tran_vsnewb;_NAME_=upcase(_NAME_);
data vsnewb(drop=variable dataset);set newdata.formats;length _name_ $21 dcm_subset_name $8;if dataset='vsnewb';_name_=variable ;run;
proc sort data=vsnewb;by dcm_subset_name _name_;run;proc sort data=tran_vsnewb out=vsnewb_data;by dcm_subset_name _name_;run;
data occ_vsnewb;set vsnewb_data ;by dcm_subset_name _name_;run;proc sort data=occ_vsnewb;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name _name_  repeat_sn ;run;
data tran.vsnewb;retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text 
qualifying_value study;
keep patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name  repeat_sn value_text qualifying_value 
study;
length dci_name dcm_question_grp_name $30 value_text $500 qualifying_value $30; set occ_vsnewb(rename=(_name_=dcm_question_name col1=value_text));
if dcm_question_name in('PATIENT','CLI_PLAN_EVE_NAME','SUBEVENT_NUMBER','DCI_NAME','DCM_NAME','DCM_SUBSET_NAME','DCM_QUESTION_GRP_NAME', 
'DCM_QUE_OCC_SN','REPEAT','REPEAT_SN','REC_N','QUALIFYING_VALUE','STUDY') then delete;run;

/***/

   /* generating the OC loadable file*/

data wbs;
retain PATIENT CLI_PLAN_EVE_NAME subevent_number DCI_NAME DCM_NAME DCM_SUBSET_NAME 
DCM_QUESTION_GRP_NAME  DCM_QUESTION_NAME DCM_QUE_OCC_SN REPEAT_SN VALUE_TEXT QUALIFYING_VALUE STUDY;
set tran.wbs1 tran.wbs1_1 tran.vsnewb;
by DCM_NAME ;
PATIENT=upcase(PATIENT);
/*CLI_PLAN_EVE_NAME=upcase(CLI_PLAN_EVE_NAME);*/
DCI_NAME=upcase(DCI_NAME);
DCM_NAME=upcase(DCM_NAME);
DCM_SUBSET_NAME=UPCASE(DCM_SUBSET_NAME); 
DCM_QUESTION_GRP_NAME=UPCASE(DCM_QUESTION_GRP_NAME); 
value_text=left(value_text);
if value_text='.' then value_text='';
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\visit.sas";
%include "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\pt_test.sas";
if value_text='' then delete;

if DCM_QUESTION_NAME='DAY1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='DAY2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='DAY3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='MONTH2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='MONTH1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='MONTH3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='YEAR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='YEAR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='YEAR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMHOUR1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMHOUR2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMMIN1' then DCM_QUE_OCC_SN=1;
else if DCM_QUESTION_NAME='TMMIN2' then DCM_QUE_OCC_SN=2;
else if DCM_QUESTION_NAME='TMHOUR3' then DCM_QUE_OCC_SN=3;
else if DCM_QUESTION_NAME='TMMIN3' then DCM_QUE_OCC_SN=3;
else DCM_QUE_OCC_SN=0;

if substr(DCM_QUESTION_NAME,1,3)='DAY' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,3);
if substr(DCM_QUESTION_NAME,1,5)='MONTH' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if substr(DCM_QUESTION_NAME,1,4)='YEAR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,4);
if substr(DCM_QUESTION_NAME,1,6)='TMHOUR' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,6);
if substr(DCM_QUESTION_NAME,1,5)='TMMIN' then DCM_QUESTION_NAME=substr(DCM_QUESTION_NAME,1,5);
if DCM_QUE_OCC_SN=. then DCM_QUE_OCC_SN=0;

run;
/*wbs*/


/*  OUTPUT CODE */

proc sort data=AEV ;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=BFS;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=CMD;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=cmp;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=cnd;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=com;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=cpl;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=dar;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=dmgf;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=edr;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=his;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=lrs2;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=pgn;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=pub;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=scr;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=slr;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=vis;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=vsn;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;
proc sort data=wbs;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;


data final;


retain patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name  dcm_question_grp_name  dcm_question_name dcm_que_occ_sn repeat_sn value_text 
qualifying_value study;
length DCM_NAME $4 ; 

length dci_name $30;
format dci_name $30.;
informat dci_name $30.;

length CLI_PLAN_EVE_NAME $30;
format CLI_PLAN_EVE_NAME $30.;
informat CLI_PLAN_EVE_NAME $30.;

set aev bfs cmd cmp cnd com cpl dar dmgf edr his lrs2 pgn pub scr slr vis vsn wbs;
by patient CLI_PLAN_EVE_NAME Subevent_Number DCI_NAME dcm_name dcm_subset_name dcm_question_grp_name;
run;

/* Preparing the final loadable file to be uploaded to Oracle Clinical*/
Data _null_;   
  file "&user\CZOL446H/CZOL446H2337/EDC_Migration/Loadable_output\EDCMigration_FileTransfer_CZOL446H2337_OCRDC_OC_LOADABLE.txt" dlm='|';
   set final;
   put (_all_) (+0);
   run;
   

