      *****************************************************************
      * Program name:    DEMO00.                                      *
      * Original author: gforrich.                                    *
      *                                                               *
      * Maintenence Log                                               *
      * Date       Author        Maintenance Requirement.             *
      * ---------- ------------  -------------------------------------*
      * 01/01/2022 gforrich      Initial Version.                     *
      * 22/03/2022 gforrich      Artifact.                            *
      * 10/04/2022 gforrich      Profile.                             *    
      *****************************************************************
      *                                                               *
      *          I D E N T I F I C A T I O N  D I V I S I O N         *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  DEMO00.
       AUTHOR. GUILLERMO FORRICH.
       INSTALLATION. IBM Z/OS.
       DATE-WRITTEN. 01/01/2022.
       DATE-COMPILED. 01/01/2022.
       SECURITY. CONFIDENTIAL.
      *****************************************************************
      *                                                               *
      *             E N V I R O N M E N T   D I V I S I O N           *
      *                                                               *
      *****************************************************************
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SPECIAL-NAMES.
              DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.

      *****************************************************************
      *              ARCHIVOS INTERVINIENTES EN EL PROCESO            *
      *****************************************************************
       FILE-CONTROL.

           SELECT S1DQ0010 ASSIGN TO S1DQ0010.
      *****************************************************************
      *                                                               *
      *                      D A T A   D I V I S I O N                *
      *                                                               *
      *****************************************************************
       DATA DIVISION.
       FILE SECTION.

       FD  S1DQ0010
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS
           RECORD CONTAINS 090 CHARACTERS.
       01  REG-S1DQ0010            PIC X(90).

       WORKING-STORAGE SECTION.

      *****************************************************************
      *                    DEFINICION DE CONSTANTES                   *
      *****************************************************************
       01  CT-CONSTANTES.
           05 CT-1                          PIC 9(01) VALUE 1.
           05 CT-MANAGER                    PIC x(08) VALUE 'MANAGER '.
      *****************************************************************
      *                    DEFINICION DE CONTADORES                   *
      *****************************************************************
       01  CN-CONTADORES.
           05 CN-REGISTROS-ESCRITOS         PIC 9(01).
      *****************************************************************
      *                     DEFINICION DE VARIABLES                   *
      *****************************************************************
       01  WS-VARIABLES.
           05 WS-IMPORTE                    PIC S9(15)V9(02) COMP-3.

           05 WS-CURRENT-DATE-DATA.
              10 WS-CURRENT-DATE.
                 15 WS-CURRENT-YEAR         PIC 9(04).
                 15 WS-CURRENT-MONTH        PIC 9(02).
                 15 WS-CURRENT-DAY          PIC 9(02).
              10 WS-CURRENT-TIME.
                 15 WS-CURRENT-HOURS        PIC 9(02).
                 15 WS-CURRENT-MINUTE       PIC 9(02).
                 15 WS-CURRENT-SECOND       PIC 9(02).
                 15 WS-CURRENT-MILLISECONDS PIC 9(02).

      *****************************************************************
      *                     DEFINICION DE COPYBOOKS                   *
      *****************************************************************
       01  WS-ATMEMP-01.
           COPY NETCEMP0.
      
      *****************************************************************
      *                                                               *
      *              P R O C E D U R E   D I V I S I O N              *
      *                                                               *
      *****************************************************************
       PROCEDURE DIVISION.
      *****************************************************************
      *                        0000-MAINLINE                          *
      *****************************************************************

       0000-MAINLINE.

           PERFORM 1000-INICIO
              THRU 1000-INICIO-EXIT

           PERFORM 2000-PROCESO
              THRU 2000-PROCESO-EXIT

           PERFORM 3000-FIN.

      *****************************************************************
      *                           1000-INICIO                         *
      *****************************************************************
       1000-INICIO.

           INITIALIZE  CN-CONTADORES

           OPEN OUTPUT S1DQ0010.
           

      *****************************************************************
      *                        1000-INICIO-EXIT                       *
      *****************************************************************
       1000-INICIO-EXIT.
           EXIT.

      *****************************************************************
      *                           2000-PROCESO                        *
      *****************************************************************
       2000-PROCESO.

           PERFORM 2100-MUEVE-DATOS
              THRU 2100-MUEVE-DATOS-EXIT.

      *****************************************************************
      *                        2000-PROCESO-EXIT                      *
      *****************************************************************
       2000-PROCESO-EXIT.
           EXIT.
      *****************************************************************
      *                       2100-MUEVE-DATOS                        *
      *****************************************************************
       2100-MUEVE-DATOS.

           INITIALIZE WS-ATMEMP-01

           MOVE '000010'                    TO EMP-EMPNO
           MOVE 'CHRISTINE   '              TO EMP-FIRSTNME
           MOVE 'I'                         TO EMP-MIDINIT 
           MOVE 'HAAS           '           TO EMP-LASTNAME
           MOVE 'A00'                       TO EMP-WORKDEPT
           MOVE '3978'                      TO EMP-PHONENO
           MOVE '1965-01-01'                TO EMP-HIREDATE
           MOVE 'PRES    '                  TO EMP-JOB
           MOVE 18                          TO EMP-EDLEVEL
           MOVE 'F'                         TO EMP-SEX
           MOVE '1933-08-14'                TO EMP-BIRTHDATE
           MOVE 52750,00                    TO EMP-SALARY
           MOVE 1000,00                     TO EMP-BONUS
           MOVE 4220,00                     TO EMP-COMM
           MOVE 'TEST'                      TO EMP-JOB
           MOVE 'TEST'                      TO EMP-JOB

           PERFORM 2300-ESCRIBE-SALIDA
              THRU 2300-ESCRIBE-SALIDA-EXIT

           INITIALIZE WS-ATMEMP-01

           MOVE '000020'                    TO EMP-EMPNO
           MOVE 'MICHAEL     '              TO EMP-FIRSTNME
           MOVE 'L'                         TO EMP-LASTNAME
           MOVE 'THOMPSON       '           TO EMP-LASTNAME
           MOVE 'B01'                       TO EMP-WORKDEPT
           MOVE '3476'                      TO EMP-PHONENO
           MOVE '1973-10-10'                TO EMP-HIREDATE
           MOVE CT-MANAGER                  TO EMP-JOB
           MOVE 18                          TO EMP-EDLEVEL
           MOVE 'M'                         TO EMP-SEX
           MOVE '1948-02-02'                TO EMP-BIRTHDATE
           MOVE 41250,00                    TO EMP-SALARY
           MOVE 800,00                      TO EMP-BONUS
           MOVE 3300,00                     TO EMP-COMM

           PERFORM 2300-ESCRIBE-SALIDA
              THRU 2300-ESCRIBE-SALIDA-EXIT

           INITIALIZE WS-ATMEMP-01

           MOVE '000030'                    TO EMP-EMPNO
           MOVE 'SALLY       '              TO EMP-FIRSTNME
           MOVE 'A'                         TO EMP-LASTNAME
           MOVE 'KWAN           '           TO EMP-LASTNAME
           MOVE 'C01'                       TO EMP-WORKDEPT
           MOVE '4738'                      TO EMP-PHONENO
           MOVE '1975-04-05'                TO EMP-HIREDATE
           MOVE CT-MANAGER                  TO EMP-JOB
           MOVE 20                          TO EMP-EDLEVEL
           MOVE 'F'                         TO EMP-SEX
           MOVE '1941-05-11'                TO EMP-BIRTHDATE
           MOVE 38250,00                    TO EMP-SALARY
           MOVE 800,00                      TO EMP-BONUS
           MOVE 3060,00                     TO EMP-COMM

           PERFORM 2300-ESCRIBE-SALIDA
              THRU 2300-ESCRIBE-SALIDA-EXIT

           INITIALIZE WS-ATMEMP-01

           MOVE '000050'                    TO EMP-EMPNO
           MOVE 'JOHN        '              TO EMP-FIRSTNME
           MOVE 'B'                         TO EMP-LASTNAME
           MOVE 'GEYER          '           TO EMP-LASTNAME
           MOVE 'E01'                       TO EMP-WORKDEPT
           MOVE '6789'                      TO EMP-PHONENO
           MOVE '1949-08-17'                TO EMP-HIREDATE
           MOVE CT-MANAGER                  TO EMP-JOB
           MOVE 16                          TO EMP-EDLEVEL
           MOVE 'M'                         TO EMP-SEX
           MOVE '1925-09-15'                TO EMP-BIRTHDATE
           MOVE 40175,00                    TO EMP-SALARY
           MOVE 800,00                      TO EMP-BONUS
           MOVE 3214,00                     TO EMP-COMM

           PERFORM 2300-ESCRIBE-SALIDA
              THRU 2300-ESCRIBE-SALIDA-EXIT

           INITIALIZE WS-ATMEMP-01

           MOVE '000060'                    TO EMP-EMPNO
           MOVE 'IRVING      '              TO EMP-FIRSTNME
           MOVE 'F'                         TO EMP-LASTNAME
           MOVE 'STERN          '           TO EMP-LASTNAME
           MOVE 'D11'                       TO EMP-WORKDEPT
           MOVE '6423'                      TO EMP-PHONENO
           MOVE '1973-09-14'                TO EMP-HIREDATE
           MOVE CT-MANAGER                  TO EMP-JOB
           MOVE 16                          TO EMP-EDLEVEL
           MOVE 'M'                         TO EMP-SEX
           MOVE '1945-07-07'                TO EMP-BIRTHDATE
           MOVE 32250,00                    TO EMP-SALARY
           MOVE 600,00                      TO EMP-BONUS
           MOVE 2580,00                     TO EMP-COMM

           PERFORM 2300-ESCRIBE-SALIDA
              THRU 2300-ESCRIBE-SALIDA-EXIT
              .

      *****************************************************************
      *                     2100-MUEVE-DATOS-EXIT                     *
      *****************************************************************
       2100-MUEVE-DATOS-EXIT.
           EXIT.

      *****************************************************************
      *                      2300-ESCRIBE-SALIDA                      *
      *****************************************************************
       2300-ESCRIBE-SALIDA.

           WRITE REG-S1DQ0010 FROM WS-ATMEMP-01

           ADD CT-1                         TO CN-REGISTROS-ESCRITOS.

      *****************************************************************
      *                    2300-ESCRIBE-SALIDA-EXIT                   *
      *****************************************************************
       2300-ESCRIBE-SALIDA-EXIT.
           EXIT.
      *****************************************************************
      *                              3000-FIN                         *
      *****************************************************************
       3000-FIN.

           PERFORM 3100-ESCRIBE-ESTADISTICAS
              THRU 3100-ESCRIBE-ESTADISTICAS-EXIT

           CLOSE S1DQ0010

                 STOP RUN.
       
      *****************************************************************
      *                     3100-ESCRIBE-ESTADISTICAS                 *
      *****************************************************************
       3100-ESCRIBE-ESTADISTICAS.

           DISPLAY '**************************************************'
           DISPLAY '*               PROGRAMA DEMO00                  *'
           DISPLAY '*                    TEST                        *'
           DISPLAY '* REGISTROS ESCRITOS:' CN-REGISTROS-ESCRITOS
           DISPLAY '*                                                *'         
           DISPLAY '**************************************************'.
      *****************************************************************
      *                   3100-ESCRIBE-ESTADISTICAS-EXIT              *
      *****************************************************************
       3100-ESCRIBE-ESTADISTICAS-EXIT.
           EXIT.