//NEJ${ENT}1100 JOB (ACCOUNT),'NEJ${ENT}2100',
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M,COND=(16,LT)
//JOBLIB   DD DSN=${SDSNLOAD}.SDSNEXIT,DISP=SHR
//         DD DSN=${SDSNLOAD}.SDSNLOAD,DISP=SHR
//***********************************************************
//*              BORRAR ARCHIVO DE SALIDA                   *
//***********************************************************
//STP0000  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEL ${HLQ}.BAT1SBAS.NEJ${ENT}2100.STP0001.MRGDEPT0
  DEL ${HLQ}.BAT1SBAS.NEJ${ENT}2100.STP0001.INCIDENT
  SET MAXCC = 0
//*
//***********************************************************
//*       PROGRAMA NE4C2100 GENERA INTERFAZ NEEC2100        *
//***********************************************************
//STP0001 EXEC PGM=IKJEFT01
//E1DQENT0 DD DSN=${HLQ}.BAT1SBAS.NEJ${ENT}2000.STP0003.SORTFB,DISP=SHR
//S1DQSAL0 DD DSN=${HLQ}.BAT1SBAS.NEJ${ENT}2100.STP0001.MGRDEPT0,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(LRECL=126,RECFM=FB)
//S2DQSAL0 DD DSN=${HLQ}.BAT1SBAS.NEJ${ENT}1100.STP0001.INCIDENT,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(LRECL=80,RECFM=FB)
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSTSIN  DD  *
   DSN SYSTEM(${DSN})
       RUN PROGRAM(NE4C1100)  -
           PLAN   (BVPT${ENT}PB)
   END
/*
//