       IDENTIFICATION DIVISION.
       PROGRAM-ID.  NE9CEMP1.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ENTRADA     ASSIGN       TO ENTRADAS                       
                              FILE STATUS  IS WS-FILE-STATUS.
           SELECT OUTFILE     ASSIGN       TO OUTFILED                      
                              FILE STATUS  IS WS-FILE-STATUS.
           SELECT OUTFIL1     ASSIGN       TO OUTFILE1                     
                              FILE STATUS  IS WS-FILE-STATUS.
           SELECT OUTFIL2     ASSIGN       TO OUTFILE2                     
                              FILE STATUS  IS WS-FILE-STATUS.        

       DATA DIVISION.
       FILE SECTION.
       FD  ENTRADA
           RECORDING MODE IS F
           RECORD CONTAINS 74 CHARACTERS.
       01  REG-ESCRIQSAM   PIC X(74).
            
      *****************************************************************
      *                                                               *
      *                     ARCHIVOS A CAMBIAR                        *
      *                                                               *
      *****************************************************************      
       FD  OUTFILE
           RECORDING MODE IS F
           RECORD CONTAINS 73 CHARACTERS.
       01  REG-OUT         PIC X(73).
                         
       FD  OUTFIL1
           RECORDING MODE IS F
           RECORD CONTAINS 75 CHARACTERS.
       01  REG-OUT1      .
           COPY UPEMP001.


       FD  OUTFIL2
           RECORDING MODE IS F
           RECORD CONTAINS 73 CHARACTERS.
       01  REG-OUT2      PIC X(73).
                 
       WORKING-STORAGE SECTION.
       01  SW-OPTIONS.
           10 SW-OP-C                        PIC X(01) VALUE 'C'.
           10 SW-OP-R                        PIC X(01) VALUE 'R'.
           10 SW-OP-U                        PIC X(01) VALUE 'U'.
           10 SW-OP-D                        PIC X(01) VALUE 'D'.
       
       01  SW-VARIABLES-X.
           05 WS-AFTER                      PIC X(15).
           05 WS-BEFORE                     PIC X(15).
           05 WS-FILE-STATUS                PIC X(02) VALUE SPACE.
           05 WS-FIN-PGM                    PIC X(02) VALUE SPACE.
           05 WS-DEPTNAME                   PIC X(36) VALUE SPACE.
       01  SW-VARIABLES-9.
           05 WS-RECORDED-1                 PIC 9(02) VALUE ZEROS.
           05 WS-RECORDED-2                 PIC 9(02) VALUE ZEROS.
           05 WS-RECORDED-3                 PIC 9(02) VALUE ZEROS.
           05 WS-DELETED                    PIC 9(02) VALUE ZEROS.
           05 WS-EXIST                      PIC 9(01) VALUE ZEROS. 

       01  REG-INSDEL.  
            COPY OTEMP001 .
       01  REG-ENTRADA.
            COPY INEMP001.

           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
              INCLUDE NEGTEMP
           END-EXEC.    
           
       PROCEDURE DIVISION.       

           PERFORM 1000-START
              THRU 1000-START-EXIT

           PERFORM 2000-PROCESS
              THRU 2000-PROCESS-EXIT
              UNTIL WS-FIN-PGM IS EQUAL TO "10" 
           PERFORM 3000-END
           .

       1000-START. 
        
           OPEN INPUT ENTRADA
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO ENTRADA" WS-FILE-STATUS
                    PERFORM 3000-END
           END-EVALUATE

           OPEN OUTPUT OUTFILE
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO READ" WS-FILE-STATUS
                    PERFORM 3000-END
           END-EVALUATE

           OPEN OUTPUT OUTFIL1
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO UPDATE" WS-FILE-STATUS
                    PERFORM 3000-END
           END-EVALUATE

           OPEN OUTPUT OUTFIL2
           EVALUATE TRUE
               WHEN WS-FILE-STATUS EQUAL '00'
                    CONTINUE 
               WHEN OTHER
                    DISPLAY "ERROR EN EL ARCHIVO DELETE" WS-FILE-STATUS
                    PERFORM 3000-END
           END-EVALUATE
           PERFORM 9000-SEARCH-REG
              THRU 9000-SEARCH-REG-EXIT  
              
           .
       1000-START-EXIT.
           EXIT.

       2000-PROCESS.
           PERFORM 2100-LEER-ARCHIVO
              THRU 2100-LEER-ARCHIVO-EXIT 

           EVALUATE IN-LETRA 
           WHEN SW-OP-C 
                IF WS-EXIST IS EQUAL TO ZEROS                 
                PERFORM 2400-CREATE
                   THRU 2400-CREATE-EXIT
                ELSE 
                   DISPLAY "EMP REG A INSERTAR YA EXISTE." 
                END-IF
           WHEN SW-OP-R
                IF WS-EXIST IS EQUAL TO 1
                   PERFORM 2500-READ
                      THRU 2500-READ-EXIT
                ELSE 
                   DISPLAY "EMP REG NO EXISTE NO SE PUEDE INSERTAR." 
                END-IF 
           WHEN SW-OP-U
                IF WS-EXIST IS EQUAL TO 1
                   PERFORM 2600-UPDATE
                      THRU 2600-UPDATE-EXIT
                ELSE 
                   DISPLAY "EMP REG NO EXISTE." 
                END-IF                
           WHEN SW-OP-D
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
       2100-LEER-ARCHIVO.
           READ ENTRADA 
                AT END
                MOVE "10" TO WS-FIN-PGM
           END-READ.

       2100-LEER-ARCHIVO-EXIT.
           EXIT.
       2400-CREATE.        
           PERFORM 9100-VALIDATION-OBL
              THRU 9100-VALIDATION-OBL-EXIT              
           EXEC SQL
              INSERT INTO NEOSB36.EMP
                  (EMPNO,
                     FIRSTNME,
                     MIDINIT,
                     LASTNAME,
                     WORKDEPT,
                     PHONENO,
                     HIREDATE,
                     JOB,
                     SEX,
                     BIRTHDATE)
              VALUES
                  (:IN-EMPNO,
                     :IN-FIRSTNME,
                     :IN-MIDINIT,
                     :IN-LASTNAME,
                     :IN-WORKDEPT,
                     :IN-PHONENO,
                     :IN-HIREDATE,
                     :IN-JOB,
                     :IN-SEX,
                     :IN-BIRTHDATE
                  )
           END-EXEC

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
                     MIDINIT,
                     LASTNAME,
                     WORKDEPT,
                     PHONENO,
                     HIREDATE,
                     JOB,
                     SEX,
                     BIRTHDATE
                INTO :IN-EMPNO,
                     :IN-FIRSTNME,
                     :IN-MIDINIT,
                     :IN-LASTNAME,
                     :IN-WORKDEPT,
                     :IN-PHONENO,
                     :IN-HIREDATE,
                     :IN-JOB,
                     :IN-SEX,
                     :IN-BIRTHDATE
                FROM NEOSB36.EMP
               WHERE EMPNO = :IN-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO LECTURA. SQLCODE: " SQLCODE
              PERFORM 3000-END 
           END-IF

           PERFORM 2900-MOVE 
              THRU 2900-MOVE-EXIT 

           WRITE REG-OUT FROM REG-INSDEL
           ADD 1 TO WS-RECORDED-2 
           
           DISPLAY "***************************************************"
           DISPLAY "EMPLEADO LEIDO"
           DISPLAY "NOMBRE: " IN-FIRSTNME 
           DISPLAY "APELLIDO: " IN-LASTNAME 
           DISPLAY "***************************************************"

           .
       2500-READ-EXIT.
           EXIT.


       2600-UPDATE.       
           PERFORM 9100-VALIDATION-OBL
              THRU 9100-VALIDATION-OBL-EXIT 
           PERFORM 9200-QUERY
              THRU 9200-QUERY-EXIT
           PERFORM  9300-ANALYSIS
              THRU  9300-ANALYSIS-EXIT
           
           EXEC SQL
              UPDATE NEOSB36.EMP
                  SET  FIRSTNME  = :IN-FIRSTNME,
                       MIDINIT   = :IN-MIDINIT,
                       LASTNAME  = :IN-LASTNAME,
                       WORKDEPT  = :IN-WORKDEPT,
                       PHONENO   = :IN-PHONENO, 
                       HIREDATE  = :IN-HIREDATE,
                       JOB       = :IN-JOB,
                       SEX       = :IN-SEX,
                       BIRTHDATE = :IN-BIRTHDATE
                  WHERE EMPNO = :IN-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO EL UPDATE. SQLCODE: " SQLCODE
              PERFORM 3000-END
           END-IF

            PERFORM 2800-MOVE-UPDATE 
               THRU 2800-MOVE-UPDATE-EXIT 

           WRITE REG-OUT 
           ADD 1 TO WS-RECORDED-2 
           
           .
       2600-UPDATE-EXIT.
           EXIT.

       2700-DELETE. 
           PERFORM 2900-MOVE 
              THRU 2900-MOVE-EXIT 

           WRITE REG-OUT2 FROM REG-INSDEL  
           ADD 1 TO WS-RECORDED-3          

           EXEC SQL
              DELETE FROM NEOSB36.EMP
              WHERE EMPNO = :IN-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO EL DELETE. SQLCODE: " SQLCODE           
              PERFORM 3000-END
           END-IF

           ADD 1 TO WS-DELETED 
           .
       2700-DELETE-EXIT.
           EXIT.

       2800-MOVE-UPDATE.
           MOVE IN-EMPNO       TO OUT-UP-EMPNO            
           MOVE IN-WORKDEPT    TO OUT-UP-WORKDEPT              
           MOVE WS-DEPTNAME    TO OUT-UP-DEPTNAME                   
           MOVE WS-AFTER       TO OUT-UP-AFTER                  
           MOVE WS-BEFORE      TO OUT-UP-BEFORE                 
           
           .
       2800-MOVE-UPDATE-EXIT.
           EXIT.
       
       2900-MOVE.
           MOVE IN-EMPNO      TO OUT-EMPNO 
           MOVE IN-FIRSTNME   TO OUT-FIRSTNME 
           MOVE IN-HIREDATE   TO OUT-HIREDATE 
           MOVE IN-BIRTHDATE  TO OUT-BIRTHDATE 
           MOVE IN-PHONENO    TO OUT-PHONENO 
           MOVE IN-JOB        TO OUT-JOB          
           MOVE IN-WORKDEPT   TO OUT-WORKDEPT 
           MOVE IN-SEX        TO OUT-SEX 
           MOVE IN-LASTNAME   TO OUT-LASTNAME  
           MOVE IN-MIDINIT    TO OUT-MIDINIT 
           .

       2900-MOVE-EXIT.
           EXIT.

       9000-SEARCH-REG.
           EXEC SQL
              SELECT EMPNO
                INTO :DCLEMP-EMPNO
                FROM NEOSB36.EMP
               WHERE EMPNO = :IN-EMPNO
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
           IF IN-EMPNO EQUAL SPACES OR LOW-VALUES
              DISPLAY "EMPNO NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF IN-FIRSTNME EQUAL SPACES OR LOW-VALUES
              DISPLAY "FIRSTNME NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF IN-LASTNAME EQUAL SPACES OR LOW-VALUES
              DISPLAY "LASTNAME NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

           IF IN-MIDINIT EQUAL SPACES OR LOW-VALUES
              DISPLAY "MIDINIT NO PUEDE SER NULL"
              PERFORM 3000-END
           END-IF

            .
       9100-VALIDATION-OBL-EXIT.
           EXIT.

       9200-QUERY.         
            EXEC SQL
              SELECT E.EMPNO,
                     E.FIRSTNME,
                     E.MIDINIT,
                     E.LASTNAME,
                     E.WORKDEPT,
                     E.PHONENO,
                     E.HIREDATE,
                     E.JOB,
                     E.SEX,
                     E.BIRTHDATE,
                     D.DEPTNAME
                INTO :DCLEMP-EMPNO,
                     :DCLEMP-FIRSTNME,
                     :DCLEMP-MIDINIT,
                     :DCLEMP-LASTNAME,
                     :DCLEMP-WORKDEPT,
                     :DCLEMP-PHONENO,
                     :DCLEMP-HIREDATE,
                     :DCLEMP-JOB,
                     :DCLEMP-SEX,
                     :DCLEMP-BIRTHDATE,
                     :WS-DEPTNAME
                FROM NEOSB36.EMP AS E
                INNER JOIN NEOSB36.DEPT AS D ON E.EMPNO = D.MGRNO
               WHERE E.EMPNO = :IN-EMPNO
           END-EXEC

           IF SQLCODE NOT EQUAL ZEROES
              DISPLAY "ERROR EJECUTANDO LECTURA. SQLCODE: " SQLCODE
              PERFORM 3000-END 
           END-IF
            
            .
       9200-QUERY-EXIT.
           EXIT.

       9300-ANALYSIS.

           IF IN-FIRSTNME IS NOT EQUAL TO DCLEMP-FIRSTNME 
              MOVE DCLEMP-FIRSTNME TO WS-BEFORE 
              MOVE IN-FIRSTNME     TO WS-AFTER 
           END-IF

           IF IN-LASTNAME IS NOT EQUAL TO DCLEMP-LASTNAME 
              MOVE DCLEMP-LASTNAME  TO WS-BEFORE 
              MOVE IN-LASTNAME      TO WS-AFTER 
           END-IF

           IF IN-MIDINIT IS NOT EQUAL TO DCLEMP-MIDINIT 
              MOVE DCLEMP-MIDINIT   TO WS-BEFORE 
              MOVE IN-MIDINIT       TO WS-AFTER 
           END-IF

           IF IN-SEX IS NOT EQUAL TO DCLEMP-SEX 
              MOVE DCLEMP-SEX       TO WS-BEFORE 
              MOVE IN-SEX           TO WS-AFTER 
           END-IF

           IF IN-WORKDEPT IS NOT EQUAL TO DCLEMP-WORKDEPT  
              MOVE DCLEMP-WORKDEPT    TO WS-BEFORE 
              MOVE IN-WORKDEPT        TO WS-AFTER 
           END-IF

           IF IN-PHONENO IS NOT EQUAL TO DCLEMP-PHONENO  
              MOVE DCLEMP-PHONENO     TO WS-BEFORE 
              MOVE IN-PHONENO         TO WS-AFTER 
           END-IF

           IF IN-HIREDATE  IS NOT EQUAL TO DCLEMP-HIREDATE   
              MOVE DCLEMP-HIREDATE    TO WS-BEFORE 
              MOVE IN-HIREDATE        TO WS-AFTER 
           END-IF

           IF IN-JOB IS NOT EQUAL TO DCLEMP-JOB 
              MOVE DCLEMP-JOB          TO WS-BEFORE 
              MOVE IN-JOB              TO WS-AFTER 
           END-IF

           IF IN-BIRTHDATE  IS NOT EQUAL TO DCLEMP-BIRTHDATE  
              MOVE DCLEMP-BIRTHDATE    TO WS-BEFORE 
              MOVE IN-BIRTHDATE        TO WS-AFTER 
           END-IF

            .
       9300-ANALYSIS-EXIT.
           EXIT.

       3000-END. 
           CLOSE OUTFILE 
           CLOSE OUTFIL1
           CLOSE OUTFIL2
           DISPLAY "REGS ELIMINADOS: " WS-DELETED
           DISPLAY "REGS GRABADOS 1: " WS-RECORDED-1   
           DISPLAY "REGS GRABADOS 2: " WS-RECORDED-2   
           DISPLAY "REGS GRABADOS 3: " WS-RECORDED-3 
           STOP RUN.