      *****************************************************************
      * Program name:    NE1C1001                                     *
      * Original author: ecampos .                                    *
      *                                                               *
      * Maintenence Log                                               *
      * Date       Author        Maintenance Requirement.             *
      * ---------- ------------  -------------------------------------*
      * 12/02/2024 ecampos      Initial Version                      *
      *****************************************************************
      *                                                               *
      *          I D E N T I F I C A T I O N  D I V I S I O N         *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  NE1C1100.
       AUTHOR. NEORIS.
       INSTALLATION. IBM Z/OS.
       DATE-WRITTEN. 12/02/2024.
       DATE-COMPILED. 12/02/2024.
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
      *****************************************************************
      *                                                               *
      *                      D A T A   D I V I S I O N                *
      *                                                               *
      *****************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *****************************************************************
      *                     DEFINICION DE VARIABLES.                  *
      *****************************************************************
       01  WS-VARIABLE.
           05 WS-MENSAJE                    PIC X(40) VALUE SPACES.
           05 WS-LARGO                      PIC S9(4) COMP.

           05 WS-COMMAREA                   PIC X(08).

      *****************************************************************
      *                    DEFINICION DE CONSTANTES.                  *
      *****************************************************************
       01  CT-CONSTANTES.
           05 CT-TRANSACCION                PIC X(04) VALUE 'NE11'.
           05 CT-NE10                       PIC X(04) VALUE 'NE10'.
           05 CT-MAPA                       PIC X(07) VALUE 'NEM1000'.
           05 CT-CRUDEMP                    PIC X(08) VALUE 'NE9CEMP0'.

      *****************************************************************
      *                    DEFINICION DE COPYBOOKS.                   *
      *****************************************************************
      * COPY DE LA TABLA DE EMPLEADOS
       COPY NETCEMP0.
       COPY NEECRET0.
       COPY NEECEMP0.
      * COPY SOPORTE BMS
       COPY DFHBMSCA.
      * COPY TOPORTE PARA TECLAS
       COPY DFHAID.
      * COPY DEL MAPA DE LA PANTALLA
       COPY NEM1100.
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
      *                        1000-INICIO                            *
      *****************************************************************
       1000-INICIO.

           INITIALIZE WS-VARIABLE

           IF EIBCALEN EQUAL ZERO
              PERFORM 1100-SEND-MAP-ONLY
                 THRU 1100-SEND-MAP-ONLY-EXIT
              PERFORM 1200-RETURN-TRANS
           END-IF.

       1000-INICIO-EXIT.
           EXIT.
      *****************************************************************
      *                     1100-SEND-MAP-ONLY                        *
      *****************************************************************
       1100-SEND-MAP-ONLY.

           MOVE LOW-VALUES                  TO NEM110MI

           EXEC CICS
                SEND MAP(CT-MAPA)
                MAPONLY
                ERASE
                NOHANDLE
           END-EXEC.

       1100-SEND-MAP-ONLY-EXIT.
           EXIT.
      *****************************************************************
      *                     1100-SEND-MAP-ONLY                        *
      *****************************************************************
       1200-RETURN-TRANS.

           MOVE LENGTH OF WS-COMMAREA       TO WS-LARGO

           EXEC CICS
                RETURN
                TRANSID(CT-TRANSACCION)
                COMMAREA(WS-COMMAREA)
                LENGTH(WS-LARGO)
           END-EXEC.

      *****************************************************************
      *                       2000-PROCESO                            *
      *****************************************************************
       2000-PROCESO.

           EXEC CICS
                RECEIVE MAP(CT-MAPA)
                   INTO (NEM110MI)
               NOHANDLE
           END-EXEC

           EVALUATE EIBRESP
               WHEN DFHRESP(NORMAL)
               WHEN DFHRESP(MAPFAIL)
                    CONTINUE
               WHEN OTHER
                    PERFORM 9000-ERROR-MAPA
           END-EVALUATE

           EVALUATE EIBAID
               WHEN DFHPF6
                    PERFORM 2100-CONSULTA-EMP
                       THRU 2100-CONSULTA-EMP-EXIT
               WHEN DFHPF2
                    PERFORM 2200-LIMPIA-EMP
                       THRU 2200-LIMPIA-EMP-EXIT
               WHEN DFHPF3
                    PERFORM 2300-REGRESA-MENU
                       THRU 2300-REGRESA-MENU-EXIT
               WHEN OTHER
                    PERFORM 9100-OPCION-NO-VALIDA
                       THRU 9100-OPCION-NO-VALIDA-EXIT
           END-EVALUATE.

       2000-PROCESO-EXIT.
           EXIT.
      *****************************************************************
      *                     2100-CONSULTA-EMP                         *
      *****************************************************************
       2100-CONSULTA-EMP.

           MOVE DFHBLINK                    TO NEM110MI
           MOVE 'OPCION F6 SELECCIONADA'    TO NEM110MO

           EXEC CICS
                RECEIVE MAP(CT-MAPA)
                INTO(NEM110MI)
                NOHANDLE
           END-EXEC.

       2100-CONSULTA-EMP-EXIT.
           EXIT.
      *****************************************************************
      *                     2100-CONSULTA-EMP                         *
      *****************************************************************
       2200-LIMPIA-EMP.

           MOVE DFHBLINK                    TO NEM110MI
           MOVE LOW-VALUES                  TO NEM110MO
           PERFORM 1100-SEND-MAP-ONLY
              THRU 1100-SEND-MAP-ONLY-EXIT
              .
       2200-LIMPIA-EMP-EXIT.
           EXIT.
      *****************************************************************
      *                     2100-CONSULTA-EMP                         *
      *****************************************************************
       2300-REGRESA-MENU.

           MOVE DFHBLINK                    TO NEM110MI
           MOVE 'OPCION F2 SELECCIONADA'    TO NEM110MO

              EXEC CICS START
                   TRANSID(CT-NE10)
                   END-EXEC.
      *
           EVALUATE EIBRESP
               WHEN DFHRESP(NORMAL)
               WHEN DFHRESP(MAPFAIL)
                    CONTINUE
               WHEN OTHER
                    PERFORM 9000-ERROR-MAPA
           END-EVALUATE.
       2300-REGRESA-MENU-EXIT.
            EXIT.
      *****************************************************************
      *                          CALL EMP TABLE                       *
      *****************************************************************
       5000-CALL-DB-EMP.

            CALL CT-CRUDEMP USING NETCEMP0,
                                  NEECRET0,
                                  NEECEMP0.
       5000-CALL-DB-EMP-EXIT.
           EXIT.
      *****************************************************************
      *                      9000-ERROR-MAPA                          *
      *****************************************************************
       9000-ERROR-MAPA.

           MOVE DFHBLINK                    TO NEM110MI
           MOVE 'ERROR EN MAPA'             TO NEM110MO

           EXEC CICS
                SEND MAP(CT-MAPA)
                ERASE
                FROM(NEM110MO)
                NOHANDLE
           END-EXEC

           PERFORM 3000-FIN.
      *****************************************************************
      *                      9000-ERROR-MAPA                          *
      *****************************************************************
       9100-OPCION-NO-VALIDA.

           MOVE DFHBLINK                    TO NEM110MI
           MOVE 'OPTION NO VALIDA'          TO NEM110MO

           EXEC CICS
                SEND MAP(CT-MAPA)
                ERASE
                FROM(NEM110MO)
                NOHANDLE
           END-EXEC.

       9100-OPCION-NO-VALIDA-EXIT.
           EXIT.

      *****************************************************************
      *                          3000-FIN                             *
      *****************************************************************
       3000-FIN.

           EXEC CICS
                RETURN
           END-EXEC.