       IDENTIFICATION DIVISION.
       PROGRAM-ID. FINALB36.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
          SPECIAL-NAMES.
              DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INFIL1     ASSIGN       TO INFILE1
                             FILE STATUS  IS SW-FILE-STATUS.
           SELECT INFIL2     ASSIGN       TO INFILE2
                             FILE STATUS  IS SW-FILE-STATUS.
           SELECT OUTFILE    ASSIGN       TO OUTFILED
                             FILE STATUS  IS SW-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  INFIL1
           RECORDING MODE IS F
           RECORD CONTAINS 90 CHARACTERS.
       01  REG-INFILE-1.
           COPY NE36EM01.

       FD  INFIL2
           RECORDING MODE IS F
           RECORD CONTAINS 64 CHARACTERS.
       01  REG-INFILE-2.
           COPY NE36EM02.

       FD  OUTFILE
            RECORDING MODE IS F
            RECORD CONTAINS 109 CHARACTERS.
       01  REG-OUTFILE2.
           COPY NE36EM03.

       WORKING-STORAGE SECTION.
       01  SW-SWITCHES.
           05 SW-FILE-STATUS                PIC X(02) VALUE SPACE.
              88 FS-88-OK                             VALUE '00'.

           05 SW-END-STATUS                   PIC X(02) VALUE 'NN'.
              88 END-STATUS-YES                         VALUE 'SS'.
              88 END-STATUS-YES1                        VALUE 'SN'.
              88 END-STATUS-YES2                        VALUE 'NS'.

       01  SW-VARIABLES-X.
           05 WS-AUX                           PIC X(03) .

       01  SW-VARIABLES-9.
           05 WS-REG-RECORD-1                  PIC 9(02) .
           05 WS-FILE-READ-1                   PIC 9(02) .
           05 WS-FILE-READ-2                   PIC 9(02) .
           05 WS-FIN-ARCHIVO1                  PIC 9(02) VALUE ZEROS.
           05 WS-FIN-ARCHIVO2                  PIC 9(02) VALUE ZEROS.

       01  SW-VARIABLES-FORMATO.
           05  FECHA-AUX.
                  10 AUX-EMP-DIA           PIC X(02). 
                  10 FILLER                PIC X(01) VALUE "/". 
                  10 AUX-EMP-MES           PIC X(02).
                  10 FILLER                PIC X(01) VALUE "/". 
                  10 AUX-EMP-ANIO          PIC X(04).

       PROCEDURE DIVISION.

           PERFORM 1000-START
              THRU 1000-START-EXIT

           PERFORM 2000-PROCESS
              THRU 2000-PROCESS-EXIT
              UNTIL SW-END-STATUS EQUAL 'SS'

           PERFORM 3000-END

           .

       1000-START.

           MOVE ZEROS TO WS-REG-RECORD-1
           MOVE ZEROS TO WS-FILE-READ-1 
           MOVE ZEROS TO WS-FILE-READ-2

           OPEN INPUT INFIL1
           IF NOT FS-88-OK
              DISPLAY 'ERROR OPEN INFILE 1 CODE: ' SW-FILE-STATUS
              PERFORM 3000-END
           END-IF

            OPEN INPUT INFIL2
           IF NOT FS-88-OK
              DISPLAY 'ERROR OPEN INFILE 2 CODE: ' SW-FILE-STATUS
              PERFORM 3000-END
           END-IF

           OPEN OUTPUT OUTFILE
           IF NOT FS-88-OK
              DISPLAY 'ERROR OPEN OUTFILE 2 CODE: ' SW-FILE-STATUS
              PERFORM 3000-END
           END-IF

           PERFORM 2100-READ-FILE1
              THRU 2100-READ-FILE1-EXIT
           PERFORM 2200-READ-FILE2
              THRU 2200-READ-FILE2-EXIT

           .
       1000-START-EXIT.
           EXIT.

       2000-PROCESS.               
           EVALUATE SW-END-STATUS  
           WHEN 'NN'
              IF DEP0-WORKDEPT IS EQUAL TO INDEP-ADMRDEPT                       
                 PERFORM 2500-WRITE-1 
                    THRU 2500-WRITE-1-EXIT               
                 PERFORM 2100-READ-FILE1
                    THRU 2100-READ-FILE1-EXIT
              ELSE
                 IF DEP0-WORKDEPT IS GREATER THAN INDEP-ADMRDEPT
                    PERFORM 2200-READ-FILE2
                       THRU 2200-READ-FILE2-EXIT
                 ELSE                   
                    PERFORM 2100-READ-FILE1
                       THRU 2100-READ-FILE1-EXIT
                 END-IF
              END-IF
           WHEN 'NS'
              PERFORM 2100-READ-FILE1
                 THRU 2100-READ-FILE1-EXIT
           WHEN 'SN'
              PERFORM 2200-READ-FILE2
                 THRU 2200-READ-FILE2-EXIT
           WHEN OTHER
                 DISPLAY "ERROR"
                 PERFORM 3000-END
           END-EVALUATE


           .
       2000-PROCESS-EXIT.
           EXIT.

       2100-READ-FILE1.
           READ INFIL1
                AT END
                MOVE 10 TO WS-FIN-ARCHIVO1
                MOVE 'SN' TO SW-END-STATUS
                NOT AT END
                ADD 1 TO WS-FILE-READ-1                
           END-READ     
           
           IF WS-FIN-ARCHIVO1 EQUAL TO 10
              AND WS-FIN-ARCHIVO2 EQUAL TO 10
                  MOVE 'SS' TO SW-END-STATUS
           END-IF 
           .
       2100-READ-FILE1-EXIT.
           EXIT.

       2200-READ-FILE2.
           READ INFIL2 
                AT END
                MOVE 10 TO WS-FIN-ARCHIVO2
                MOVE 'NS' TO SW-END-STATUS
                NOT AT END
                ADD 1 TO WS-FILE-READ-2
           END-READ

           IF WS-FIN-ARCHIVO1 EQUAL TO 10
              AND WS-FIN-ARCHIVO2 EQUAL TO 10
                  MOVE 'SS' TO SW-END-STATUS
           END-IF

              .
       2200-READ-FILE2-EXIT.
           EXIT.

       2300-ANALISYS.
           EVALUATE INDEP-ADMRDEPT 
              WHEN 'A00'
                 MOVE "BS AS" TO OUT-LOCATION 
                 MOVE INDEP-DEPTNO   TO OUT-DEPTNO
                 MOVE INDEP-DEPTNAME TO OUT-DEPTNAME 
              WHEN 'D01'
                 MOVE "CORDOBA" TO OUT-LOCATION 
                 MOVE INDEP-DEPTNO   TO OUT-DEPTNO
                 MOVE INDEP-DEPTNAME TO OUT-DEPTNAME 
              WHEN 'E01'
                 MOVE "MENDOZA" TO OUT-LOCATION 
                 MOVE INDEP-DEPTNO   TO OUT-DEPTNO
                 MOVE INDEP-DEPTNAME TO OUT-DEPTNAME 
              WHEN OTHER 
                 MOVE SPACES TO OUT-LOCATION 
                 MOVE SPACES  TO OUT-DEPTNO
                 MOVE SPACES TO OUT-DEPTNAME  
              END-EVALUATE
            .
       2300-ANALISYS-EXIT.
           EXIT.

       2400-MOVE.                            
   
           MOVE DEP0-FIRSTNME  TO OUT-FIRSTNME
           MOVE DEP0-EMPNO     TO OUT-EMPNO
           MOVE DEP0-FIRSTNME  TO OUT-FIRSTNME
           MOVE DEP0-LASTNAME  TO OUT-LASTNAME
           MOVE DEP0-JOB       TO OUT-JOB
           MOVE DEP0-EMP-ANIO  TO AUX-EMP-ANIO 
           MOVE DEP0-EMP-MES   TO AUX-EMP-MES
           MOVE DEP0-EMP-DIA   TO AUX-EMP-DIA
           MOVE FECHA-AUX      TO OUT-BIRTHDATE  
           MOVE INDEP-ADMRDEPT TO OUT-ADMRDEPT              
            .
       2400-MOVE-EXIT.
           EXIT.

       2500-WRITE-1.          
           PERFORM 2300-ANALISYS 
              THRU 2300-ANALISYS-EXIT
           PERFORM 2400-MOVE 
              THRU 2400-MOVE-EXIT 

           ADD 1 TO WS-REG-RECORD-1
           WRITE REG-OUTFILE2
            .
       2500-WRITE-1-EXIT.
           EXIT.

     
       9100-CLOSE-FILES.
           CLOSE INFIL1 
           CLOSE INFIL2
           CLOSE OUTFILE 
           .
       9100-CLOSE-FILES-EXIT.
           EXIT.

       3000-END.
           PERFORM 9100-CLOSE-FILES 
              THRU 9100-CLOSE-FILES-EXIT
           DISPLAY "REGISTROS LEIDOS INFILE 1  : " WS-FILE-READ-1
           DISPLAY "REGISTROS LEIDOS INFILE 2  : " WS-FILE-READ-2
           DISPLAY "REGISTROS GRABADOS OUTFILED : " WS-REG-RECORD-1 


           .
           STOP RUN.