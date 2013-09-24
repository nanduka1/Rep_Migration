/*****************************************************************************/
/* PROGRAM  : Format.sas                                                     */
/* AUTHOR   : Kaushik Nanduri                                                */
/* DATE     : 06-Sep-2013                                                    */
/* FUNCTION : To download the formats from CT4 to work library               */
/*                                                                           */
/* MODIFICATION HISTORY:                                                     */
/*                                                                           */
/* Init Date        Description                                              */
/* ==== =========== ======================================================== */
/* K.N  06-Sep-2013  Initial Version                                         */
/*                                                                           */
/*****************************************************************************/

proc download incat=data_s.formats outcat=work.formats; 
run;

