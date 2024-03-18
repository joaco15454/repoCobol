       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRECRUD.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUTFILE     ASSIGN       TO OUTFILED                      
                              FILE STATUS  IS WS-FILE-STATUS.
           SELECT OUTFIL1     ASSIGN       TO OUTFILE1                     
                              FILE STATUS  IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  OUTFILE
           RECORDING MODE IS F
           RECORD CONTAINS 74 CHARACTERS.
       01  REG-OUT.
            COPY PREXOUT.

       FD  OUTFIL1
           RECORDING MODE IS F
           RECORD CONTAINS 74 CHARACTERS.
       01  REG-OUT1.
            COPY PREXOUT1.

       WORKING-STORAGE SECTION.
       01  SW-OPTIONS.
           10 SW-OP-C                        PIC X(01) VALUE 'C'.
           10 SW-OP-R                        PIC X(01) VALUE 'R'.
           10 SW-OP-U                        PIC X(01) VALUE 'U'.
           10 SW-OP-D                        PIC X(01) VALUE 'D'.
       
       01  SW-VARIABLES.
           05 WS-EXIST                      PIC 9(01). 
           05 WS-AUX                        PIC X(10).
           05 WS-FILE-STATUS                PIC X(02) VALUE SPACE.
           05 WS-RECORDED-1                 PIC 9(02) VALUE ZEROS.
           05 WS-RECORDED-2                 PIC 9(02) VALUE ZEROS.
           05 WS-DELETED                    PIC 9(02) VALUE ZEROS.
              
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
              INCLUDE NEGTEMP
           END-EXEC.    
       
       LINKAGE SECTION.
       01  REG-ESCRIQSAM.
            COPY PREXAMO.
           
       PROCEDURE DIVISION USING REG-ESCRIQSAM.       

           PERFORM 1000-START
              THRU 1000-START-EXIT

           PERFORM 2000-PROCESS
              THRU 2000-PROCESS-EXIT

           PERFORM 3000-END
           .

       1000-START.    
           OPEN OUTPUT OUTFILE
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO OUTPUT1" WS-FILE-STATUS
                    PERFORM 3000-END
           END-EVALUATE

           OPEN OUTPUT OUTFIL1
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO OUTPUT2" WS-FILE-STATUS
                    PERFORM 3000-END
           END-EVALUATE

           PERFORM 9000-SEARCH-REG
             THRU 9000-SEARCH-REG-EXIT  
              
           .
       1000-START-EXIT.
           EXIT.

       2000-PROCESS.
           EVALUATE EMP-LETRA 
           WHEN SW-OP-C 
                MOVE 0 TO  WS-EXIST 
                IF WS-EXIST IS EQUAL TO ZEROS                 
                PERFORM 2400-CREATE
                   THRU 2400-CREATE-EXIT
                ELSE 
                   DISPLAY "EMP REG A INSERTAR YA EXISTE." 
                END-IF
           WHEN SW-OP-R 
                MOVE 1 TO  WS-EXIST 
                IF WS-EXIST IS EQUAL TO 1
                   PERFORM 2500-READ
                      THRU 2500-READ-EXIT
                ELSE 
                   DISPLAY "EMP REG NO EXISTE." 
                END-IF 
           WHEN SW-OP-U
                MOVE 1 TO  WS-EXIST 
                IF WS-EXIST IS EQUAL TO 1
                   PERFORM 2600-UPDATE
                      THRU 2600-UPDATE-EXIT
                ELSE 
                   DISPLAY "EMP REG NO EXISTE." 
                END-IF                
           WHEN SW-OP-D
                MOVE 1 TO  WS-EXIST 
                IF WS-EXIST IS EQUAL TO 1
                   PERFORM 2700-DELETE
                      THRU 2700-DELETE-EXIT
                ELSE 
                   DISPLAY "EMP REG NO EXISTE." 
                END-IF                 
           WHEN OTHER
               DISPLAY "ERROR. INCORRECT OPTION"
           END-EVALUATE
           .
       2000-PROCESS-EXIT.
           EXIT.

       2400-CREATE.        
           PERFORM 9100-VALIDATION-OBL
              THRU 9100-VALIDATION-OBL-EXIT  
              MOVE "1984-12-04" TO WS-AUX
              MOVE "000234" TO  EMP-EMPNO 
           EXEC SQL
              INSERT INTO NEOSB36.EMP
                  (EMPNO,FIRSTNME,MIDINIT,LASTNAME,WORKDEPT,
                   PHONENO,HIREDATE,JOB,SEX,BIRTHDATE)
              VALUES
                  (:EMP-EMPNO,
                    :EMP-FIRSTNME,
                    :EMP-MIDINIT,
                    :EMP-LASTNAME,
                    :EMP-WORKDEPT,
                    :EMP-PHONENO,
                    :EMP-HIREDATE,
                    :EMP-JOB,
                    :EMP-SEX,
                    :WS-AUX    
                  )
           END-EXEC
           DISPLAY "EMP EMPNO: " EMP-EMPNO 
           DISPLAY "EMP NAME: " EMP-FIRSTNME 
           DISPLAY "EMP MIDNIIT: " EMP-MIDINIT 
           DISPLAY "EMP LASTNAME: " EMP-LASTNAME 
           DISPLAY "EMP WORKDEPT: " EMP-WORKDEPT 
           DISPLAY "EMP PHONENO: " EMP-PHONENO 
           DISPLAY "EMP HIREDATE: " EMP-HIREDATE 
           DISPLAY "EMP JOB: " EMP-JOB 
           DISPLAY "EMP SEX: " EMP-SEX 
           DISPLAY "EMP AUX(FECHA): " WS-AUX 

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO EL INSERT. SQLCODE: " SQLCODE
              PERFORM 3000-END
           END-IF       
           .
       2400-CREATE-EXIT.
           EXIT.

       2500-READ. 
           
           EXEC SQL
              SELECT EMPNO,
                     FIRSTNME,
                     LASTNAME,
                     WORKDEPT,
                     PHONENO,
                     HIREDATE,
                     JOB,
                     SEX,
                     BIRTHDATE
                INTO :EMP-EMPNO,
                     :EMP-FIRSTNME,
                     :EMP-LASTNAME,
                     :EMP-WORKDEPT,
                     :EMP-PHONENO,
                     :EMP-HIREDATE,
                     :EMP-JOB,
                     :EMP-SEX,
                     :DCLEMP-BIRTHDATE  
                FROM NEOSB36.EMP
               WHERE EMPNO = :EMP-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO LECTURA. SQLCODE: " SQLCODE
              PERFORM 3000-END 
           ELSE
              DISPLAY "EMPNO: " DCLEMP-EMPNO  
           END-IF

           PERFORM 2900-MOVE 
              THRU 2900-MOVE-EXIT 

           WRITE REG-OUT
           ADD 1 TO WS-RECORDED-2 
           .
       2500-READ-EXIT.
           EXIT.


       2600-UPDATE.
           MOVE 'X' TO WS-AUX 
           PERFORM 9100-VALIDATION-OBL
              THRU 9100-VALIDATION-OBL-EXIT 

           EXEC SQL
              UPDATE NEOSB36.EMP
                  SET  FIRSTNME = :EMP-FIRSTNME,
                       MIDINIT = :WS-AUX,
                       LASTNAME = :EMP-LASTNAME,
                       WORKDEPT = :EMP-WORKDEPT,
                       PHONENO = :EMP-PHONENO, 
                       HIREDATE = :EMP-HIREDATE,
                       JOB = :EMP-JOB,
                       SEX = :EMP-SEX,
                       BIRTHDATE = :DCLEMP-BIRTHDATE  
                  WHERE EMPNO = :EMP-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO EL UPDATE. SQLCODE: " SQLCODE
              
           
           .
       2600-UPDATE-EXIT.
           EXIT.

       2700-DELETE.
           
           PERFORM 2800-RECORD
              THRU 2800-RECORD-EXIT 

           EXEC SQL
              DELETE FROM NEOSB36.EMP
              WHERE EMPNO = :EMP-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO EL DELETE. SQLCODE: " SQLCODE           
              PERFORM 3000-END
           END-IF

           ADD 1 TO WS-DELETED 
           .
       2700-DELETE-EXIT.
           EXIT.

       2800-RECORD.

           PERFORM 2900-MOVE 
              THRU 2900-MOVE-EXIT 

           WRITE REG-OUT1 
           ADD 1 TO WS-RECORDED-2          
           .
       2800-RECORD-EXIT.
           EXIT.

       
       2900-MOVE.

           MOVE EMP-EMPNO     TO OUT-EMP-EMPNO 
           MOVE EMP-FIRSTNME  TO OUT-EMP-FIRSTNME 
           MOVE EMP-HIREDATE  TO OUT-EMP-HIREDATE 
           MOVE DCLEMP-BIRTHDATE  TO OUT-EMP-FECHA-AUX   
           MOVE EMP-PHONENO   TO OUT-EMP-PHONENO 
           MOVE EMP-JOB       TO OUT-EMP-JOB          
           MOVE EMP-LETRA     TO OUT-EMP-LETRA 
           MOVE EMP-WORKDEPT  TO OUT-EMP-WORKDEPT 
           MOVE EMP-SEX       TO OUT-EMP-SEX 
           .

       2900-MOVE-EXIT.
           EXIT.

       9000-SEARCH-REG.
           EXEC SQL
              SELECT EMPNO
                INTO :DCLEMP-EMPNO
                FROM NEOSB36.EMP
               WHERE EMPNO = :EMP-EMPNO
           END-EXEC

           EVALUATE SQLCODE
           WHEN ZEROES
              MOVE 1 TO WS-EXIST
           WHEN 100             
              MOVE 0 TO WS-EXIST 
           WHEN OTHER
              DISPLAY "ERROR. SQLCODE: " SQLCODE
              PERFORM 3000-END
           END-EVALUATE           
            .
       9000-SEARCH-REG-EXIT.
           EXIT.
       
       9100-VALIDATION-OBL.
           IF EMP-LETRA EQUAL SPACES OR LOW-VALUES
              DISPLAY "EMP-LETRA NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-EMPNO EQUAL SPACES OR LOW-VALUES
              DISPLAY "EMPNO NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-FIRSTNME EQUAL SPACES OR LOW-VALUES
              DISPLAY "FIRSTNME NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-LASTNAME EQUAL SPACES OR LOW-VALUES
              DISPLAY "LASTNAME NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-WORKDEPT EQUAL SPACES OR LOW-VALUES
              DISPLAY "WORKDEPT NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-PHONENO EQUAL SPACES OR LOW-VALUES
              DISPLAY "PHONENO NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-HIREDATE EQUAL SPACES OR LOW-VALUES
              DISPLAY "HIREDATE NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-JOB EQUAL SPACES OR LOW-VALUES
              DISPLAY "JOB NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF EMP-SEX EQUAL SPACES OR LOW-VALUES
              DISPLAY "SEX NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

            .
       9100-VALIDATION-OBL-EXIT.
           EXIT.

       3000-END. 
           CLOSE OUTFILE 
           CLOSE OUTFIL1
           DISPLAY "REGS ELIMINADOS: " WS-DELETED
           DISPLAY "REGS GRABADOS 1: " WS-RECORDED-1   
           DISPLAY "REGS GRABADOS 2: " WS-RECORDED-2   
           STOP RUN.