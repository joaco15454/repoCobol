
      *****************************************************************
      * Program name:    DEMO01.                                      *
      * Original author: gforrich.                                    *
      *                                                               *
      * Maintenence Log                                               *
      * Date       Author        Maintenance Requirement.             *
      * ---------- ------------  -------------------------------------*
      * 22/02/2022 gforrich      Initial Version.                     *
      * 14/08/2023 gforrich      Sonar GateWay.                       *     
      *****************************************************************
      *****************************************************************
      *                                                               *
      *          I D E N T I F I C A T I O N  D I V I S I O N         *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  DEMO01.
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

           SELECT E1DQ0010 ASSIGN TO E1DQ0010.

           SELECT S1DQ0010 ASSIGN TO S1DQ0010.
      *****************************************************************
      *                                                               *
      *                      D A T A   D I V I S I O N                *
      *                                                               *
      *****************************************************************
       DATA DIVISION.
       FILE SECTION.
       FD  E1DQ0010
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS
           RECORD CONTAINS  90 CHARACTERS.
       01  REG-E1DQ0010            PIC X(90).

       FD  S1DQ0010
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS
           RECORD CONTAINS 120 CHARACTERS.
       01  REG-S1DQ0010            PIC X(120).

       WORKING-STORAGE SECTION.
       
       01  WS-VARIABLES.
           
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
           
           05 WS-CURRENT-DATE-DDMMAAAA.
              10 WS-CURRENT-DD              PIC 9(02).
              10 WS-CURRENT-MM              PIC 9(02).
              10 WS-CURRENT-AAAA            PIC 9(04).

           05 WS-FECHA-AUX.
              10 WS-FECHA-AUX-AAAA          PIC X(04).
              10 FILLER                     PIC X(01).
              10 WS-FECHA-AUX-MM            PIC X(02).
              10 FILLER                     PIC X(01).
              10 WS-FECHA-AUX-DD            PIC X(02).

           05 WS-HIREDATE.
              10 WS-HIREDATE-DD             PIC 9(02).
              10 WS-HIREDATE-MM             PIC 9(02).
              10 WS-HIREDATE-AAAA           PIC 9(04).
              
           05 WS-BIRTHDATE.
              10 WS-BIRTHDATE-DD            PIC X(02).
              10 WS-BIRTHDATE-MM            PIC X(02).
              10 WS-BIRTHDATE-AAAA          PIC X(04).

           05 WS-BONUS-BIRTHDATE            PIC S9(09)V9(02) COMP-3.           

      *****************************************************************
      *                     DEFINICION DE SWITCHES                    *
      *****************************************************************
       01  SW-SWITCHES.

           05 SW-FIN-ARCHIVO                PIC X(01) VALUE 'N'.
              88 SI-FIN-ARCHIVO                       VALUE 'S'.
              88 NO-FIN-ARCHIVO                       VALUE 'N'.

      *****************************************************************
      *                    DEFINICION DE CONSTANTES                   *
      *****************************************************************
       01  CT-CONSTANTES.
           05 CT-1                          PIC 9(01) VALUE 1.
           05 CT-RUTINA00                   PIC X(08) VALUE 'RUTINA00'.
           05 CT-TC8C1220                   PIC x(08) VALUE 'TC8C1220'.
           05 CT-COD-ERROR                  PIC S9(4) COMP VALUE 9999.
           05 CT-OPCION-3                   PIC 9(01) VALUE 3.
           05 CT-RETORNO-OK                 PIC X(02) VALUE '00'. 
      *****************************************************************
      *                    DEFINICION DE CONTADORES                   *
      *****************************************************************
       01  CN-CONTADORES.
           05 CN-REGISTROS-LEIDO            PIC 9(01).
           05 CN-REGISTROS-ESCRITOS         PIC 9(01).

      *****************************************************************
      *                     DEFINICION DE COPYBOOKS                   *
      *****************************************************************
       01  WS-NETCEMP0-01.
           COPY NETCEMP0.
       01  WS-NEEC0001-01.
           COPY NEEC0001.    
       01  WS-WMECRET0-01.
           COPY NEECRET0.

           COPY TCWC1750.

      *****************************************************************
      *                                                               *
      *              P R O C E D U R E   D I V I S I O N              *
      *                                                               *
      *****************************************************************
       PROCEDURE DIVISION.
      *****************************************************************
      *                            MAIN LINE                          *
      *****************************************************************

       0000-MAINLINE.

           PERFORM 1000-INICIO
              THRU 1000-INICIO-EXIT

           PERFORM 2000-PROCESO
              THRU 2000-PROCESO-EXIT
             UNTIL SI-FIN-ARCHIVO

           PERFORM 3000-FIN.

      *****************************************************************
      *                           1000-INICIO                         *
      *****************************************************************
       1000-INICIO.

           INITIALIZE  CN-CONTADORES
           OPEN INPUT  E1DQ0010
           OPEN OUTPUT S1DQ0010

           MOVE FUNCTION CURRENT-DATE       TO WS-CURRENT-DATE-DATA
           MOVE WS-CURRENT-DAY              TO WS-CURRENT-DD 
           MOVE WS-CURRENT-MONTH            TO WS-CURRENT-MM 
           MOVE WS-CURRENT-YEAR             TO WS-CURRENT-AAAA

           PERFORM 1100-LEER-ARCHIVO
              THRU 1100-LEER-ARCHIVO-EXIT.

      *****************************************************************
      *                         1000-INICIO-EXIT                      *
      *****************************************************************
       1000-INICIO-EXIT.
           EXIT.
      *****************************************************************
      *                        1100-LEER-ARCHIVO                      *
      *****************************************************************
       1100-LEER-ARCHIVO.

           READ E1DQ0010 INTO WS-NETCEMP0-01
                AT END
                SET SI-FIN-ARCHIVO          TO TRUE
           END-READ

           IF NO-FIN-ARCHIVO
              ADD CT-1                      TO CN-REGISTROS-LEIDO
           END-IF.

      *****************************************************************
      *                       1100-LEER-ARCHIVO-EXIT                  *
      *****************************************************************
       1100-LEER-ARCHIVO-EXIT.
           EXIT.
      *****************************************************************
      *                           2000-PROCESO                        *
      *****************************************************************
       2000-PROCESO.
           
           PERFORM 2100-CALCULA-AUMENTO 
              THRU 2100-CALCULA-AUMENTO-EXIT
           
           PERFORM 2200-MUEVE-DATOS
              THRU 2200-MUEVE-DATOS-EXIT

           PERFORM 2300-ESCRIBE-SALIDA
              THRU 2300-ESCRIBE-SALIDA-EXIT

           PERFORM 1100-LEER-ARCHIVO
              THRU 1100-LEER-ARCHIVO-EXIT.

      *****************************************************************
      *                       2000-PROCESO-EXIT                       *
      *****************************************************************
       2000-PROCESO-EXIT.
           EXIT.
      *****************************************************************
      *                       2100-CALCULA-AUMENT                     *
      *****************************************************************
       2100-CALCULA-AUMENTO.

           INITIALIZE WS-NEEC0001-01
      
      * Si este año cumple 5 - 10 - 20 años en la empresa
      * incremento % de la cantidad de año
           
           MOVE EMP-HIREDATE                TO WS-FECHA-AUX
           COMPUTE WS-HIREDATE-DD   = FUNCTION NUMVAL(WS-FECHA-AUX-DD)
           COMPUTE WS-HIREDATE-MM   = FUNCTION NUMVAL(WS-FECHA-AUX-MM) 
           COMPUTE WS-HIREDATE-AAAA = FUNCTION NUMVAL(WS-FECHA-AUX-DD)  

           INITIALIZE TCWC1750 

           MOVE CT-OPCION-3                 TO W175-CDOPCIO 
           MOVE WS-CURRENT-DATE-DDMMAAAA    TO W175-FHGRE1
           MOVE WS-HIREDATE                 TO W175-FHGRE2

           PERFORM 9000-CALCULA-FECHAS
              THRU 9000-CALCULA-FECHAS-EXIT

           MOVE ZEROS                       TO 0001-SALARY-INC
           
           IF W175-NUMDIAS IS GREATER THAN 1824 AND 
              W175-NUMDIAS IS LESS THAN 3650
              
              MULTIPLY EMP-SALARY BY 0,05 GIVING 0001-SALARY-INC

           END-IF

           IF W175-NUMDIAS IS GREATER THAN 3649 AND 
              W175-NUMDIAS IS LESS THAN 7300

              MULTIPLY EMP-SALARY BY 0,1 GIVING 0001-SALARY-INC

           END-IF 
           
           IF W175-NUMDIAS IS GREATER THAN 7299

              MULTIPLY EMP-SALARY BY 0,2 GIVING 0001-SALARY-INC

           END-IF 

      * Si ademas está cumpleño el dia de hoy
      * le damos un 2% de incremento
           
           MOVE EMP-BIRTHDATE               TO WS-FECHA-AUX 
           MOVE WS-FECHA-AUX-DD             TO WS-BIRTHDATE-DD
           MOVE WS-FECHA-AUX-MM             TO WS-BIRTHDATE-MM 
           MOVE WS-FECHA-AUX-AAAA           TO WS-BIRTHDATE-AAAA

           INITIALIZE TCWC1750 

           MOVE CT-OPCION-3                 TO W175-CDOPCIO 
           MOVE WS-CURRENT-DATE-DDMMAAAA    TO W175-FHGRE1
           MOVE WS-BIRTHDATE                TO W175-FHGRE2

           PERFORM 9000-CALCULA-FECHAS
              THRU 9000-CALCULA-FECHAS-EXIT

           IF W175-NUMDIAS EQUAL ZERO 

              MULTIPLY 0001-SALARY BY 1,02 GIVING 0001-SALARY 

           END-IF.

      *****************************************************************
      *                       2100-RECUPERA-DEP                       *
      *****************************************************************
       2100-CALCULA-AUMENTO-EXIT.
           EXIT.

      *****************************************************************
      *                       2100-RECUPERA-DEP                       *
      *****************************************************************
       2200-MUEVE-DATOS.

           MOVE EMP-EMPNO                   TO 0001-EMPNO
           MOVE EMP-FIRSTNME                TO 0001-FIRSTNME
           MOVE EMP-MIDINIT                 TO 0001-MIDINIT
           MOVE EMP-LASTNAME                TO 0001-LASTNAME
           MOVE EMP-WORKDEPT                TO 0001-WORKDEPT
           MOVE EMP-PHONENO                 TO 0001-PHONENO
           MOVE EMP-HIREDATE                TO 0001-HIREDATE
           MOVE EMP-JOB                     TO 0001-JOB
           MOVE EMP-EDLEVEL                 TO 0001-EDLEVEL
           MOVE EMP-SEX                     TO 0001-SEX
           MOVE EMP-BIRTHDATE               TO 0001-BIRTHDATE
           MOVE EMP-SALARY                  TO 0001-SALARY
           MOVE EMP-BONUS                   TO 0001-BONUS
           MOVE EMP-COMM                    TO 0001-COMM.

      *****************************************************************
      *                       2100-RECUPERA-DEP                       *
      *****************************************************************
       2200-MUEVE-DATOS-EXIT.
           EXIT.

      *****************************************************************
      *                      2300-ESCRIBE-SALIDA                      *
      *****************************************************************
       2300-ESCRIBE-SALIDA.

           WRITE REG-S1DQ0010 FROM WS-NEEC0001-01

           ADD CT-1                         TO CN-REGISTROS-ESCRITOS.

      *****************************************************************
      *                       2100-RECUPERA-DEP                       *
      *****************************************************************
       2300-ESCRIBE-SALIDA-EXIT.
           EXIT.
      *****************************************************************
      *                              3000-FIN                         *
      *****************************************************************
       3000-FIN.

           PERFORM 3100-ESCRIBE-ESTADISTICAS
              THRU 3100-ESCRIBE-ESTADISTICAS-EXIT

           CLOSE E1DQ0010
                 S1DQ0010

           STOP RUN.

      *****************************************************************
      *                     3100-ESCRIBE-ESTADISTICAS                 *
      *****************************************************************
       3100-ESCRIBE-ESTADISTICAS.

           DISPLAY '***********************************************'
           DISPLAY 'REGISTROS LEIDOS:'   CN-REGISTROS-LEIDO
           DISPLAY 'REGISTROS ESCRITOS:' CN-REGISTROS-ESCRITOS
           DISPLAY '***********************************************'.

      *****************************************************************
      *                     3100-ESCRIBE-ESTADISTICAS                 *
      *****************************************************************
       3100-ESCRIBE-ESTADISTICAS-EXIT.
           EXIT.
      
      *****************************************************************
      *                        9000-CALCULA-FECHAS                    *
      *****************************************************************
       9000-CALCULA-FECHAS.

           CALL CT-TC8C1220 USING TCWC1750

           IF W175-CDRETORN NOT EQUAL CT-RETORNO-OK

              DISPLAY 'ERROR EN REGISTRO:' CN-REGISTROS-LEIDO
              DISPLAY 'CALCULO DE FECHAS:' W175-FHGRE1 W175-FHGRE2 
              DISPLAY 'CODIGO DE RETORNO:' W175-CDRETORN

           END-IF.

       9000-CALCULA-FECHAS-EXIT.
           EXIT.
