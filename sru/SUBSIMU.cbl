       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUBSIMU.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUTFIL3  ASSIGN TO OUTFILE3
                           ORGANIZATION IS INDEXED
                           ACCESS MODE IS DYNAMIC
                           RECORD KEY IS OUT-EMPNO 
                           FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  OUTFIL3.
       01  REG-OUT.
            COPY SIMUOUT.


       WORKING-STORAGE SECTION.      

       01  SW-VARIABLES.
           05 WS-FILE-STATUS                PIC X(02) VALUE SPACE.
           05 WS-RECORDED-1                 PIC 9(02) VALUE ZEROS.
              
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
              INCLUDE NEGTEMP
           END-EXEC.    
       
       LINKAGE SECTION.
       01  LN-VAR.
            COPY PREXAMO.
           
       PROCEDURE DIVISION USING LN-VAR.       

           PERFORM 1000-START
              THRU 1000-START-EXIT

           PERFORM 2000-PROCESS
              THRU 2000-PROCESS-EXIT

           PERFORM 3000-END
           .

       1000-START. 

           OPEN OUTPUT OUTFIL3
           IF WS-FILE-STATUS IS NOT EQUAL '00'
              DISPLAY 'ERROR OPEN OUTFILE 1 CODE: ' WS-FILE-STATUS
              PERFORM 3000-END
           END-IF                
           .
       1000-START-EXIT.
           EXIT.

       2000-PROCESS.           
           IF EMP-LETRA IS EQUAL TO 'R' OR 'r'
                   PERFORM 2500-READ
                      THRU 2500-READ-EXIT
                ELSE 
                   DISPLAY "OPCION INCORRECTA." 
            END-IF   
    
           .
       2000-PROCESS-EXIT.
           EXIT.

       2500-READ.            
           EXEC SQL
              SELECT EMPNO,
                     FIRSTNME,
                     MIDINIT,
                     LASTNAME,
                     WORKDEPT,
                     PHONENO,
                     HIREDATE,
                     JOB,
                     SEX,
                     BIRTHDATE
                INTO :DCLEMP-EMPNO,
                     :DCLEMP-FIRSTNME,
                     :DCLEMP-MIDINIT,
                     :DCLEMP-LASTNAME,
                     :DCLEMP-WORKDEPT,
                     :DCLEMP-PHONENO,
                     :DCLEMP-HIREDATE,
                     :DCLEMP-JOB,
                     :DCLEMP-SEX,
                     :DCLEMP-BIRTHDATE  
                FROM NEOSB36.EMP
               WHERE EMPNO = :EMP-EMPNO 
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO LECTURA. SQLCODE: " SQLCODE
              PERFORM 3000-END 
           END-IF
           
           PERFORM 9100-VALIDATION-OBL 
              THRU 9100-VALIDATION-OBL-EXIT 

           PERFORM 2900-MOVE 
              THRU 2900-MOVE-EXIT 
           WRITE REG-OUT
           ADD 1 TO WS-RECORDED-1
           .
       2500-READ-EXIT.
           EXIT.

        2900-MOVE.
           MOVE DCLEMP-EMPNO         TO OUT-EMPNO 
           MOVE DCLEMP-FIRSTNME      TO OUT-FIRSTNME 
           MOVE DCLEMP-HIREDATE      TO OUT-HIREDATE 
           MOVE DCLEMP-MIDINIT       TO OUT-MIDINIT 
           MOVE DCLEMP-PHONENO       TO OUT-PHONENO 
           MOVE DCLEMP-BIRTHDATE     TO OUT-BIRTHDATE    
           MOVE DCLEMP-PHONENO       TO OUT-PHONENO 
           MOVE DCLEMP-JOB           TO OUT-JOB          
           MOVE DCLEMP-WORKDEPT      TO OUT-WORKDEPT 
           MOVE DCLEMP-SEX           TO OUT-SEX
           .

       2900-MOVE-EXIT.
           EXIT.


      
       9100-VALIDATION-OBL.
           IF DCLEMP-EMPNO EQUAL SPACES OR LOW-VALUES
              DISPLAY "EMPNO NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF DCLEMP-FIRSTNME EQUAL SPACES OR LOW-VALUES
              DISPLAY "FIRSTNME NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF DCLEMP-LASTNAME EQUAL SPACES OR LOW-VALUES
              DISPLAY "LASTNAME NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF DCLEMP-MIDINIT  EQUAL SPACES OR LOW-VALUES
              DISPLAY "MIDINIT NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

            .
       9100-VALIDATION-OBL-EXIT.
           EXIT.

       3000-END. 
           CLOSE OUTFIL3 
           DISPLAY "REGS GRABADOS EN ARCHIVO DE LEIDOS: " WS-RECORDED-1    
           STOP RUN.