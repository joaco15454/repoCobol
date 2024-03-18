      ******************************************************************
      *                                                                *
      * NOMBRE DEL OBJETO:  NEEC0001                                   *
      *                                                                *
      * DESCRIPCION:  AREA DE COMUNICACION PARA INFORMACION DE ERRORES *
      *                                                                *
      * -------------------------------------------------------------- *
      *                                                                *
      *           LONGITUD : 703 POSICIONES.                           *
      *           PREFIJO  : 0001.                                     *
      *                                                                *
      ******************************************************************
                                                                        
           05 NEEC0001.
              10 0001-EMPNO                     PIC X(06).
              10 0001-FIRSTNME                  PIC X(12).
              10 0001-MIDINIT                   PIC X(01).
              10 0001-LASTNAME                  PIC X(15).
              10 0001-WORKDEPT                  PIC X(03).
              10 0001-PHONENO                   PIC X(04).
              10 0001-HIREDATE                  PIC X(10).
              10 0001-JOB                       PIC X(08).
              10 0001-EDLEVEL                   PIC S9(04) USAGE COMP.
              10 0001-SEX                       PIC X(01).
              10 0001-BIRTHDATE                 PIC X(10).
              10 0001-SALARY                    PIC S9(09)V9(02) COMP-3.
              10 0001-BONUS                     PIC S9(09)V9(02) COMP-3.
              10 0001-COMM                      PIC S9(09)V9(02) COMP-3.
              10 WS-INCREMENTO.
                 15 0001-SALARY-INC             PIC S9(09)V9(02) COMP-3.
                 15 0001-BONUS-INC              PIC S9(09)V9(02) COMP-3.
                 15 0001-COMM-INC               PIC S9(09)V9(02) COMP-3.
              10 FILLER                         PIC X(12).
                 

              