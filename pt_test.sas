/*****************************************************************************/
/* PROGRAM  : pt_test.sas                                                    */
/* AUTHOR   : Kaushik Nanduri                                                */
/* DATE     : 06-Sep-2013                                                    */
/* FUNCTION : To convert the CT4 patients to OC Test patients                */
/*                                                                           */
/* MODIFICATION HISTORY:                                                     */
/*                                                                           */
/* Init Date        Description                                              */
/* ==== =========== ======================================================== */
/* K.N  06-Sep-2013  Initial Version                                         */
/*                                                                           */
/*****************************************************************************/

if patient='0001_00003' then patient='Z101';
else if patient='0001_00007' then patient='Z102';
else if patient='0001_00017' then patient='Z103';
else if patient='0001_00019' then patient='Z104';
else if patient='0010_00006' then patient='Z105';
else if patient='0012_00007' then patient='Z106';
else if patient='0018_00001' then patient='Z107';
else if patient='0019_00002' then patient='Z108';
else if patient='0019_00003' then patient='Z109';
else if patient='0019_00005' then patient='Z110';
else if patient='0019_00009' then patient='Z111';
else if patient='0019_00010' then patient='Z112';
else if patient='0019_00012' then patient='Z113';
else if patient='0025_00026' then patient='Z114';
else if patient='0026_00005' then patient='Z115';
else if patient='0001_00001' then patient='Z116';
else if patient='0001_00002' then patient='Z117';
else if patient='0001_00004' then patient='Z118';
else if patient='0001_00005' then patient='Z119';
else if patient='0001_00006' then patient='Z120';
else if patient='0001_00008' then patient='Z121';
else if patient='0001_00009' then patient='Z122';
else if patient='0001_00010' then patient='Z123';
else if patient='0001_00011' then patient='Z124';
else if patient='0001_00012' then patient='Z125';
else if patient='0001_00013' then patient='Z126';
else if patient='0001_00014' then patient='Z127';
else if patient='0001_00015' then patient='Z128';
else if patient='0001_00016' then patient='Z129';
else if patient='0001_00018' then patient='Z130';
else if patient='0010_00001' then patient='Z131';
else if patient='0010_00002' then patient='Z132';
else if patient='0010_00003' then patient='Z133';
else if patient='0010_00004' then patient='Z134';
else if patient='0010_00005' then patient='Z135';
else if patient='0010_00007' then patient='Z136';
else if patient='0010_00008' then patient='Z137';
else if patient='0011_00001' then patient='Z138';
else if patient='0011_00002' then patient='Z139';
else if patient='0011_00003' then patient='Z140';
else if patient='0011_00004' then patient='Z141';
else if patient='0011_00005' then patient='Z142';
else if patient='0011_00006' then patient='Z143';
else if patient='0011_00007' then patient='Z144';
else if patient='0011_00008' then patient='Z145';
else if patient='0011_00009' then patient='Z146';
else if patient='0011_00010' then patient='Z147';
else if patient='0011_00011' then patient='Z148';
else if patient='0011_00012' then patient='Z149';
else if patient='0011_00013' then patient='Z150';
else if patient='0011_00014' then patient='Z151';
else if patient='0011_00015' then patient='Z152';
else if patient='0012_00001' then patient='Z153';
else if patient='0012_00002' then patient='Z154';
else if patient='0012_00003' then patient='Z155';
else if patient='0012_00004' then patient='Z156';
else if patient='0012_00005' then patient='Z157';
else if patient='0012_00006' then patient='Z158';
else if patient='0012_00008' then patient='Z159';
else if patient='0012_00009' then patient='Z160';
else if patient='0012_00011' then patient='Z161';
else if patient='0012_00012' then patient='Z162';
else if patient='0012_00013' then patient='Z163';
else if patient='0012_00014' then patient='Z164';
else if patient='0013_00001' then patient='Z165';
else if patient='0013_00002' then patient='Z166';
else if patient='0013_00003' then patient='Z167';
else if patient='0013_00004' then patient='Z168';
else if patient='0014_00001' then patient='Z169';
else if patient='0016_00001' then patient='Z170';
else if patient='0016_00002' then patient='Z171';
else if patient='0016_00003' then patient='Z172';
else if patient='0016_00004' then patient='Z173';
else if patient='0016_00005' then patient='Z174';
else if patient='0016_00006' then patient='Z175';
else if patient='0016_00007' then patient='Z176';
else if patient='0017_00001' then patient='Z177';
else if patient='0018_00002' then patient='Z178';
else if patient='0018_00003' then patient='Z179';
else if patient='0018_00004' then patient='Z180';
else if patient='0019_00001' then patient='Z181';
else if patient='0019_00004' then patient='Z182';
else if patient='0019_00006' then patient='Z183';
else if patient='0019_00007' then patient='Z184';
else if patient='0019_00008' then patient='Z185';
else if patient='0019_00011' then patient='Z186';
else if patient='0025_00001' then patient='Z187';
else if patient='0025_00002' then patient='Z188';
else if patient='0025_00003' then patient='Z189';
else if patient='0025_00004' then patient='Z190';
else if patient='0025_00005' then patient='Z191';
else if patient='0025_00006' then patient='Z192';
else if patient='0025_00007' then patient='Z193';
else if patient='0025_00008' then patient='Z194';
else if patient='0025_00009' then patient='Z195';
else if patient='0025_00010' then patient='Z196';
else if patient='0025_00011' then patient='Z197';
else if patient='0025_00012' then patient='Z198';
else if patient='0025_00013' then patient='Z199';
else if patient='0025_00014' then patient='Z200';
else if patient='0025_00015' then patient='Z201';
else if patient='0025_00016' then patient='Z202';
else if patient='0025_00017' then patient='Z203';
else if patient='0025_00018' then patient='Z204';
else if patient='0025_00019' then patient='Z205';
else if patient='0025_00020' then patient='Z206';
else if patient='0025_00021' then patient='Z207';
else if patient='0025_00022' then patient='Z208';
else if patient='0025_00023' then patient='Z209';
else if patient='0025_00024' then patient='Z210';
else if patient='0025_00025' then patient='Z211';
else if patient='0025_00027' then patient='Z212';
else if patient='0025_00028' then patient='Z213';
else if patient='0025_00029' then patient='Z214';
else if patient='0025_00030' then patient='Z215';
else if patient='0026_00001' then patient='Z216';
else if patient='0026_00002' then patient='Z217';
else if patient='0026_00003' then patient='Z218';
else if patient='0026_00004' then patient='Z219';
else if patient='0026_00006' then patient='Z220';
else if patient='0026_00007' then patient='Z221';
else if patient='0026_00008' then patient='Z222';
else if patient='0026_00009' then patient='Z223';
else if patient='0041_00001' then patient='Z224';
else if patient='0046_00001' then patient='Z225';
else if patient='0046_00002' then patient='Z226';
else if patient='0046_00003' then patient='Z227';
else if patient='0046_00004' then patient='Z228';
else if patient='0046_00005' then patient='Z229';
else if patient='0046_00006' then patient='Z230';
else if patient='0046_00007' then patient='Z231';
else if patient='0046_00008' then patient='Z232';
else if patient='0046_00009' then patient='Z233';
else if patient='0046_00010' then patient='Z234';
else if patient='0001_00020' then patient='Z235';
else if patient='0001_00021' then patient='Z236';
else if patient='0001_00022' then patient='Z237';
else if patient='0010_00009' then patient='Z238';
else if patient='0026_00010' then patient='Z239';
else if patient='0001_00023' then patient='Z240';
else if patient='0001_00024' then patient='Z241';
else if patient='0001_00025' then patient='Z242';
else if patient='0001_00026' then patient='Z243';










