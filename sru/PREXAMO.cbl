       IDENTIFICATION DIVISION.
       PROGRAM-ID.  PREXAMO.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALIDAS     ASSIGN       TO SALIDASE                       
                              FILE STATUS  IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  SALIDAS
           RECORDING MODE IS F
           RECORD CONTAINS 74 CHARACTERS.
       01  REG-ESCRIQSAM.
            COPY PREXAMO.

       WORKING-STORAGE SECTION.


       01  WS-VARIABLES-PGM.
           05 WS-FIN-PGM                   PIC X(02) VALUE '1'.
           05 WS-FILE-STATUS               PIC X(02) VALUE SPACE.
           05 WS-FILE-READ                 PIC 9(01) VALUE ZERO.
       01 WS-CALLING-SUB                    PIC X(07) VALUE 'PRECRUD'.
    
       01  WS-VARIABLES-FORMATO.
           05  FECHA-AUX.
                  10 AUX-DIA           PIC X(02). 
                  10 FILLER            PIC X(01) VALUE "/". 
                  10 AUX-MES           PIC X(02).
                  10 FILLER            PIC X(01) VALUE "/". 
                  10 AUX-ANIO          PIC X(04).
          
            
      ******************************************************************
      *                      SQL SECTION                               *
      ******************************************************************
           EXEC SQL INCLUDE SQLCA  END-EXEC.

           EXEC SQL INCLUDE NEGTEMP END-EXEC.

       PROCEDURE DIVISION.
           PERFORM 1000-INICIO
              THRU 1000-INICIO-EXIT

           PERFORM 2000-PROCESO
              THRU 2000-PROCESO-EXIT
              UNTIL WS-FIN-PGM IS EQUAL TO "10"
           PERFORM 3000-FINAL
           .

      ******************************************************************
      *                      APERTURAS                                 *
      ******************************************************************
       1000-INICIO.

           OPEN INPUT SALIDAS
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO SALISE" WS-FILE-STATUS
                    PERFORM 3000-FINAL
           END-EVALUATE
           PERFORM 2100-LEER-ARCHIVO
              THRU 2100-LEER-ARCHIVO-EXIT
           .
       1000-INICIO-EXIT.
           EXIT.

      ******************************************************************
      *                     LOGICA DEL PROGRAMA                        *
      ******************************************************************

       2000-PROCESO.
               MOVE AUX-EMP-ANIO TO AUX-ANIO 
               MOVE AUX-EMP-DIA TO AUX-DIA 
               MOVE AUX-EMP-MES TO AUX-MES 
               DISPLAY "EMP-LETRA: " EMP-LETRA
               DISPLAY "EMP-EMPNO: " EMP-EMPNO
               DISPLAY "EMP-FIRSTNME: " EMP-FIRSTNME
               DISPLAY "EMP-LASTNAME: " EMP-LASTNAME
               DISPLAY "EMP-WORKDEPT: " EMP-WORKDEPT
               DISPLAY "EMP-PHONENO: " EMP-PHONENO
               DISPLAY "EMP-HIREDATE: " EMP-HIREDATE   
               DISPLAY "EMP-JOB: " EMP-JOB
               DISPLAY "EMP-SEX: " EMP-SEX   
               DISPLAY "EMP-BIRT: " EMP-FECHA-AUX    
               IF EMP-LETRA IS EQUAL TO 'D'
                 CALL WS-CALLING-SUB USING REG-ESCRIQSAM 
               END-IF
               
               PERFORM 2100-LEER-ARCHIVO 
                  THRU 2100-LEER-ARCHIVO-EXIT  
              .
           
       2000-PROCESO-EXIT.
           EXIT.
     
       2100-LEER-ARCHIVO.
           READ SALIDAS 
                AT END
                MOVE "10" TO WS-FIN-PGM
                NOT AT END
                ADD 1 TO WS-FILE-READ
           END-READ.

       2100-LEER-ARCHIVO-EXIT.
           EXIT.

       3000-FINAL.
           DISPLAY "ARCHIVOS LEIDOS: " WS-FILE-READ
           CLOSE  SALIDAS
           STOP RUN.
 
           
