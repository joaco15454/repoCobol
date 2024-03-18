      *                                                                *
      * DESCRIPCION:  AREA DE COMUNICACION PARA INFORMACION DE ERRORES *
      *                                                                *
      * -------------------------------------------------------------- *
      *                                                                *
      *           LONGITUD : 74  POSICIONES.                           *
      *                                                                *
      **********************
           05 OUT1-NETCEMP0.
           10 OUT1-EMP-LETRA                         PIC X(01).
           10 OUT1-EMP-EMPNO                         PIC X(06).
           10 OUT1-EMP-FIRSTNME                      PIC X(12).
           10 OUT1-EMP-MIDINIT                       PIC X(01).
           10 OUT1-EMP-LASTNAME                      PIC X(15).
           10 OUT1-EMP-WORKDEPT                      PIC X(03).
           10 OUT1-EMP-PHONENO                       PIC X(04).
           10 OUT1-EMP-HIREDATE                      PIC X(10).
           10 OUT1-EMP-JOB                           PIC X(08).
           10 FILLER                                 PIC X(02).
           10 OUT1-EMP-SEX                           PIC X(01).
           10 OUT1-EMP-FECHA-AUX.
                  11 OUT1-AUX-EMP-ANIO          PIC X(04).
                  11 FILLER                     PIC X(01). 
                  11 OUT1-AUX-EMP-MES           PIC X(02).
                  11 FILLER                     PIC X(01). 
                  11 OUT1-AUX-EMP-DIA           PIC X(02).