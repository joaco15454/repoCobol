      ******************************************************************
      * NOMBRE DEL OBJETO:  EMPEMP.                                    *
      *                                                                *
      * DESCRIPCION: AREA DE COMUNICACION PARA RUTINA DE EMPLEADOS.    *
      *                                                                *
      * -------------------------------------------------------------- *
      *                                                                *
      *           LONGITUD : 90 POSICIONES.                           *
      *           PREFIJO  : EMP.                                      *
      *                                                                *
      ******************************************************************
       05  NETCEMP0-OUT.
           10 OUT-EMPNO                         PIC X(06).
           10 OUT-FIRSTNME                      PIC X(12).
           10 OUT-MIDINIT                       PIC X(01).
           10 OUT-LASTNAME                      PIC X(15).
           10 OUT-WORKDEPT                      PIC X(03).
           10 OUT-PHONENO                       PIC X(04).
           10 OUT-HIREDATE                      PIC X(10).
           10 OUT-JOB                           PIC X(08).
           10 OUT-SEX                           PIC X(01).
           10 OUT-BIRTHDATE                     PIC X(10).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 14      *
      * THE LENGHT OF COLUMNS DESCRIBED BY THIS DECLARATION IS 90      *
      ******************************************************************