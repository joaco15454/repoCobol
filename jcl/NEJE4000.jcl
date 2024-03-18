//NEJ${ENT}4000 JOB (ACCOUNT),'NEJ${ENT}4000',
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M,COND=(16,LT)
//JOBLIB   DD DSN=${SDSNLOAD}.SDSNEXIT,DISP=SHR
//         DD DSN=${SDSNLOAD}.SDSNLOAD,DISP=SHR
//***********************************************************
//*              BORRAR ARCHIVO DE SALIDA                   *
//***********************************************************
//STP0000  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEL ${HLQ}.NEJ${ENT}4000.DEMO00.UNLOAD
  DEL ${HLQ}.NEJ${ENT}4000.DEMO00.SYSPUNCH
  DEL ${HLQ}.NEJ${ENT}4000.DEMO00.SORT
  DEL ${HLQ}.NEJ${ENT}4000.DEMO00.SORTFB
  SET MAXCC = 0
//*
//***********************************************************
//*               DESCARGA TABLA EMPLEADOS                  *
//***********************************************************
//STP0001 EXEC DSNUPROC,SYSTEM=${DSN},UID=LOADIND
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  UNLOAD DATA FROM TABLE DSN81010.ACT
/*
//SYSREC   DD DSN=${HLQ}.NEJ${ENT}4000.DEMO00.UNLOAD,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(10,5),RLSE)
//SYSPUNCH DD DSN=${HLQ}.NEJ${ENT}4000.DEMO00.SYSPUNCH,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(LRECL=80,RECFM=FB)
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//***********************************************************
//*         CONVIERTE ARCHIVO DE LARGO VARIABLE A FIJO      *
//***********************************************************
//STP0002 EXEC SORT,PARM=('DYNALLOC=(SYSALLDA,32)')
//SORTIN   DD DSN=${HLQ}.NEJ${ENT}4000.DEMO00.UNLOAD,DISP=SHR
//SORTOUT  DD DSN=${HLQ}.NEJ${ENT}4000.DEMO00.SORT,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(10,5),RLSE)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  OPTION COPY
  OUTFIL FNAMES=SORTOUT,VTOF,OUTREC=(5,32)
/*
//***********************************************************
//*         SORT TABLE POR CLAVE Y ELIMINAR ESPACIOS        *
//***********************************************************
//STP0003 EXEC SORT,PARM=('DYNALLOC=(SYSALLDA,32)')
//SORTIN   DD DSN=${HLQ}.NEJ${ENT}4000.DEMO00.SORT,DISP=SHR
//SORTOUT  DD DSN=${HLQ}.NEJ${ENT}4000.DEMO00.SORTFB,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(10,5),RLSE),
//            DCB=(LRECL=26,RECFM=FB)
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  SORT FIELDS=(3,1,CH,A)
  OUTREC FIELDS=(3,1,5,6,13,19)  
/*
//