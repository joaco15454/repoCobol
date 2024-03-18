/* REXX */
/*
***********************************************************************
* Dynamic file generated by Neoris' CB Editor extension for z/OS. Any
*
* Name acctinfo.rexx
* 
* Creation date
* Wed, 23 Aug 2023 11:50:50 GMT
*
* Mofification date
* Wed, 23 Aug 2023 11:50:50 GMT
*
* Description
* Servicio ACCTINFO para SCLM 
***********************************************************************
*/
PARSE ARG PROJ GRUPO TIPO MEMBER RESTO
Address isredit 'MACRO'
Address isredit '(MEMBER) = MEMBER'
Address isredit '(DS) = DATASET'
'FLMCMD ACCTINFO,NEOS,,DEV1,SOURCE,'MEMBER
Say  'acctinfo rc = ' rc
Say  'member name = ' zsambr
Say  'language    = ' zsalang
Say  'change date = ' zsaldat4
Say  'SCLM creation =' ZSACTIME
Say  'Baseline ='ZSABTIME
Say  'Number of includesm='ZSAINCNT
say 'Group where the member was last changed ='ZSALGRP
say 'Userid that last changed the member     ='ZSALUSER
say 'SCLM Type                               ='ZSATYPE
say 'An include for a member                 ='ZSIMBR
say ' Number of the user entry               ='ZSUNUM
say 'Last time a change code was assigned    ='ZSCTIME
say 'Version number of the member            ='ZSAVER
say 'Number of user entries for the member   ='ZSAUECNT
say 'Version of the translator that generated='ZSAMTVER
say 'Time the member was last changed        ='ZSALTIME
say 'Number of includes for the member       ='ZSAINCNT
say ' Authorization code                     ='ZSAAUTH
Say  'acctinfo rc = ' rc