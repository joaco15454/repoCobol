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
       05  NETCEMP0.
           10 EMP-EMPNO                         PIC X(06).
           10 EMP-FIRSTNME                      PIC X(12).
           10 EMP-MIDINIT                       PIC X(01).
           10 EMP-LASTNAME                      PIC X(15).
           10 EMP-WORKDEPT                      PIC X(03).
           10 EMP-PHONENO                       PIC X(04).
           10 EMP-HIREDATE                      PIC X(10).
           10 EMP-JOB                           PIC X(08).
           10 EMP-EDLEVEL                       PIC S9(04) USAGE COMP.
           10 EMP-SEX                           PIC X(01).
           10 EMP-BIRTHDATE                     PIC X(10).
           10 EMP-SALARY                        PIC S9(09)V9(02) COMP-3.
           10 EMP-BONUS                         PIC S9(09)V9(02) COMP-3.
           10 EMP-COMM                          PIC S9(09)V9(02) COMP-3.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 14      *
      * THE LENGHT OF COLUMNS DESCRIBED BY THIS DECLARATION IS 90      *
      ******************************************************************