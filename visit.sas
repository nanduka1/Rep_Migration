/*****************************************************************************/
/* PROGRAM  : visit.sas                                                      */
/* AUTHOR   : Kaushik Nanduri                                                */
/* DATE     : 06-Sep-2013                                                    */
/* FUNCTION : To map the CT4 visits to OC visits                             */
/*                                                                           */
/* MODIFICATION HISTORY:                                                     */
/*                                                                           */
/* Init Date        Description                                              */
/* ==== =========== ======================================================== */
/* K.N  06-Sep-2013  Initial Version                                         */
/*                                                                           */
/*****************************************************************************/


if CLI_PLAN_EVE_NAME='Screening' then CLI_PLAN_EVE_NAME='SCREENING';
else if CLI_PLAN_EVE_NAME='Randomization' then CLI_PLAN_EVE_NAME='RANDOMIZATION';
else if CLI_PLAN_EVE_NAME='Visit 3, day 9-11' then CLI_PLAN_EVE_NAME='VISIT 3';
else if CLI_PLAN_EVE_NAME='Visit 4, day 90, T' then CLI_PLAN_EVE_NAME='VISIT 4';
else if CLI_PLAN_EVE_NAME='Visit 5, day 180' then CLI_PLAN_EVE_NAME='VISIT 5';
else if CLI_PLAN_EVE_NAME='Visit 6, day 9-11' then CLI_PLAN_EVE_NAME='VISIT 6';
else if CLI_PLAN_EVE_NAME='Visit 7, day 270, T' then CLI_PLAN_EVE_NAME='VISIT 7';
else if CLI_PLAN_EVE_NAME='End of study' then CLI_PLAN_EVE_NAME='END OF STUDY';
else if CLI_PLAN_EVE_NAME='Summary' then CLI_PLAN_EVE_NAME='SUMMARY';
else if CLI_PLAN_EVE_NAME='Unscheduled Visit' then CLI_PLAN_EVE_NAME='UNSCHEDULED';

