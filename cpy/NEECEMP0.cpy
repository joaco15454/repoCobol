      ******************************************************************
      *                                                                *
      * NOMBRE DEL OBJETO:  NEECDEP0                                   *
      *                                                                *
      * DESCRIPCION:  AREA DE COMUNICACION PARA INFORMACION DE ERRORES *
      *                                                                *
      * -------------------------------------------------------------- *
      *                                                                *
      *           LONGITUD : 703 POSICIONES.                           *
      *           PREFIJO  : DEP0.                                     *
      *                                                                *
      ******************************************************************
                                                                        
           05 NEECDEP0.
              10 DEP0-OPCION                    PIC X(01).
                 88 DEP0-88-CREATE                        VALUE 'C'.            
                 88 DEP0-88-READ                          VALUE 'R'.            
                 88 DEP0-88-UPDATE                        VALUE 'U'.            
                 88 DEP0-88-DELETE                        VALUE 'D'.      
              10 DEP0-EMPNO                     PIC X(06).
              10 DEP0-FIRSTNME                  PIC X(12).
              10 DEP0-MIDINIT                   PIC X(01).
              10 DEP0-LASTNAME                  PIC X(15).
              10 DEP0-WORKDEPT                  PIC X(03).
              10 DEP0-PHONENO                   PIC X(04).
              10 DEP0-HIREDATE                  PIC X(10).
              10 DEP0-JOB                       PIC X(08).
              10 DEP0-EDLEVEL                   PIC S9(04) USAGE COMP.
              10 DEP0-SEX                       PIC X(01).
              10 DEP0-BIRTHDATE                 PIC X(10).
              10 DEP0-SALARY                    PIC S9(09)V9(02) COMP-3.
              10 DEP0-BONUS                     PIC S9(09)V9(02) COMP-3.
              10 DEP0-COMM                      PIC S9(09)V9(02) COMP-3.        
              