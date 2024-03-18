//NEJ${ENT}1000 JOB (ACCOUNT),'NEJ${ENT}1000',
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M,COND=(16,LT)
//JOBLIB   DD DSN=${SDSNLOAD}.SDSNEXIT,DISP=SHR
//         DD DSN=${SDSNLOAD}.SDSNLOAD,DISP=SHR
//***********************************************************
//*              BORRAR ARCHIVO DE SALIDA                   *
//***********************************************************
//STP0000  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEL ${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0001.UNLOAD
  DEL ${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0001.SYSPUNCH
  DEL ${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0002.SORT
  DEL ${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0003.SORTFB
  SET MAXCC = 0
//*
//***********************************************************
//*              DESCARGA TABLA EMPLEADOS                   *
//***********************************************************
//STP0001 EXEC DSNUPROC,SYSTEM=${DSN},UID=LOADIND
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  UNLOAD DATA FROM TABLE DSN81310.EMP
/*
//SYSREC   DD DSN=${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0001.UNLOAD,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(10,5),RLSE)
//SYSPUNCH DD DSN=${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0001.SYSPUNCH,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(LRECL=80,RECFM=FB)
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//DSNUPROC.SORTWK01 DD DSN=&&SORTWK01,
//    DISP=(NEW,DELETE,DELETE),
//    SPACE=(4000,(1000,700),,,ROUND),
//    UNIT=SYSDA
//DSNUPROC.SORTWK02 DD DSN=&&SORTWK02,
//    DISP=(NEW,DELETE,DELETE),
//    SPACE=(4000,(1000,700),,,ROUND),
//    UNIT=SYSDA
//DSNUPROC.SORTWK03 DD DSN=&&SORTWK03,
//    DISP=(NEW,DELETE,DELETE),
//    SPACE=(4000,(1000,700),,,ROUND),
//    UNIT=SYSDA
//DSNUPROC.SORTWK04 DD DSN=&&SORTWK04,
//    DISP=(NEW,DELETE,DELETE),
//    SPACE=(4000,(1000,700),,,ROUND),
//    UNIT=SYSDA
//DSNUPROC.SYSUT1 DD DSN=&&SYSUT1,
//    DISP=(NEW,DELETE,DELETE),
//    SPACE=(4000,(5000,2000),,,ROUND),
//    UNIT=SYSDA
//***********************************************************
//*       CONVIERTE ARCHIVO DE LARGO VARIABLE A FIJO        *
//***********************************************************
//STP0002 EXEC PGM=SORT,PARM=('DYNALLOC=(SYSALLDA,32)')
//SORTIN   DD DSN=${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0001.UNLOAD,DISP=SHR
//SORTOUT  DD DSN=${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0002.SORT,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(10,5),RLSE)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  OPTION COPY
  OUTFIL FNAMES=SORTOUT,VTOF,OUTREC=(5,103)  
/*
//***********************************************************
//*        SORT TABLE POR CLAVE Y ELIMINAR ESPACIOS         *
//***********************************************************
//STP0003 EXEC PGM=SORT,PARM=('DYNALLOC=(SYSALLDA,32)')
//SORTIN   DD DSN=${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0002.SORT,DISP=SHR
//SORTOUT  DD DSN=${AMB}.BAT1SBAS.NEJ${ENT}1000.STP0003.SORTFB,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(10,5),RLSE),
//            DCB=(LRECL=90,RECFM=FB)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  SORT FIELDS=(3,6,CH,A)
  INCLUDE COND=(3,6,CH,LE,C'000340')
  OUTREC FIELDS=(3,6,11,12,23,1,26,15,42,3,
                 46,4,51,10,62,8,71,2,74,1,
                 76,10,86,6,92,6,98,6)
  
/*
//
//***********************************************************
//*                    FIN JCL NEJE1000                    *
//***********************************************************