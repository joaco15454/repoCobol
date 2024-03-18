       IDENTIFICATION DIVISION.
       PROGRAM-ID.  SUBUO2.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ENTRADA     ASSIGN       TO ENTRADAS                       
                              FILE STATUS  IS WS-FILE-STATUS.
                                              
       DATA DIVISION.
       FILE SECTION.
       FD  ENTRADA
           RECORDING MODE IS F
           RECORD CONTAINS 74 CHARACTERS.
       01  REG-ENTRADA.
           COPY PREXAMO.

       WORKING-STORAGE SECTION.

       01  WS-VARIABLES-ARCHIVO.
           05 WS-FILE-STATUS               PIC X(02) VALUE SPACE.
           05 WS-CONTADOR-ESCRITO          PIC 9(02) VALUE 0.
           05 WS-FILE-READ-DB2             PIC 9(02) VALUE 0.
           05 WS-CALLING-SUB               PIC X(05) VALUE 'COBO1'.
           
       01  WS-VARIABLES-LECT.
           05 WS-FIN-ARCH                   PIC X(02) VALUE ZEROES .           
           
      ******************************************************************
      *                      SQL SECTION                               *
      ******************************************************************
           EXEC SQL INCLUDE SQLCA  END-EXEC.

           EXEC SQL INCLUDE NEGTEMP END-EXEC.

            EXEC SQL
              DECLARE CUR1 CURSOR FOR
              SELECT         E.EMPNO,
                             E.FIRSTNME,
                             E.MIDINIT,
                             E.LASTNAME,
                             E.WORKDEPT,
                             E.PHONENO,
                             E.HIREDATE,
                             E.JOB,
                             E.EDLEVEL,
                             E.SEX,
                             E.BIRTHDATE,
                             E.SALARY,
                             E.BONUS,
                             E.COMM
            FROM NEOSB36.EMP AS E INNER JOIN NEOSB36.DEPT AS D 
            ON E.EMPNO = D.MGRNO              
            END-EXEC.

       PROCEDURE DIVISION.

           PERFORM 1000-INICIO
              THRU 1000-INICIO-EXIT

           PERFORM 2000-PROCESO
              THRU 2000-PROCESO-EXIT
              UNTIL WS-FIN-ARCH IS EQUAL TO "10"

           PERFORM 3000-FINAL.

       1000-INICIO.

           OPEN INPUT ENTRADA
           IF WS-FILE-STATUS IS NOT EQUAL '00'
              DISPLAY 'ERROR OPEN ENTRADA  CODE: ' WS-FILE-STATUS
              PERFORM 3000-FINAL
           ELSE 
              PERFORM 2100-LEER-ARCHIVO
                 THRU 2100-LEER-ARCHIVO-EXIT          
              display "entro primer lectura" 
           END-IF 
           
                     
           .
       1000-INICIO-EXIT.
           EXIT.

       2000-PROCESO.    
           DISPLAY EMP-LETRA 
           PERFORM 2400-CALL
              THRU 2400-CALL-EXIT
              
      **     PERFORM 2500-APAREO
      **        THRU 2500-APAREO-EXIT               
              .

       2000-PROCESO-EXIT.
           EXIT.
           
       2100-LEER-ARCHIVO.
           READ ENTRADA 
                AT END
                MOVE "10" TO WS-FIN-ARCH
           END-READ.

       2100-LEER-ARCHIVO-EXIT.
           EXIT.

        2400-CALL.
            CALL WS-CALLING-SUB USING REG-ENTRADA

            PERFORM 2100-LEER-ARCHIVO 
               THRU 2100-LEER-ARCHIVO-EXIT
              display "entro segunda" 
      
           . 
       2400-CALL-EXIT.
           EXIT.

       2500-APAREO.

           EXEC SQL
              OPEN CUR1
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROS
              DISPLAY "ERROR EN APERTURA DE CURSOR.SQLCODE : " SQLCODE
              PERFORM 3000-FINAL 
           END-IF
            
            PERFORM UNTIL SQLCODE EQUAL TO +100
            
            EXEC SQL
               FETCH CUR1
               INTO :DCLEMP-EMPNO,
                    :DCLEMP-FIRSTNME,
                    :DCLEMP-MIDINIT,
                    :DCLEMP-LASTNAME,
                    :DCLEMP-WORKDEPT,
                    :DCLEMP-PHONENO,
                    :DCLEMP-HIREDATE,
                    :DCLEMP-JOB,
                    :DCLEMP-EDLEVEL,
                    :DCLEMP-SEX,
                    :DCLEMP-BIRTHDATE,
                    :DCLEMP-SALARY,
                    :DCLEMP-BONUS,
                    :DCLEMP-COMM
           END-EXEC
           
           IF SQLCODE IS EQUAL ZEROS
              ADD 1 TO WS-CONTADOR-ESCRITO              
           ELSE
              DISPLAY "CURSOR ERROR.SQLCODE : " SQLCODE
              PERFORM 3000-FINAL 
           END-IF
           END-PERFORM 

                      
           EXEC SQL
              CLOSE CUR1
           END-EXEC

            IF SQLCODE NOT EQUAL ZEROS
              DISPLAY "CIERRE CURSOR MAL:  " SQLCODE
           END-IF
       
           . 
       2500-APAREO-EXIT.
           EXIT.

     
       3000-FINAL.

           DISPLAY "LLEGO " 

           STOP RUN.
