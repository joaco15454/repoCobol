      *****************************************************************
      * Program name:    NE1C1000                                     *
      * Original author: gforrich.                                    *
      *                                                               *
      * Maintenence Log                                               *
      * Date       Author        Maintenance Requirement.             *
      * ---------- ------------  -------------------------------------*
      * 03/09/2022 gforrich      Initial Version.                     *
      * 31/08/2023 gforrich      Activa F2.                           *
      *****************************************************************
      *                                                               *
      *          I D E N T I F I C A T I O N  D I V I S I O N         *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  NE1C1000.
       AUTHOR. GUILLERMO FORRICH.
       INSTALLATION. IBM Z/OS.
       DATE-WRITTEN. 18/03/2023.
       DATE-COMPILED. 18/03/2023.
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
           05 WS-TRANSACCION                PIC X(04) VALUE SPACES.
           05 WS-COMMAREA                   PIC X(08).

      *****************************************************************
      *                    DEFINICION DE CONSTANTES.                  *
      *****************************************************************
       01  CT-CONSTANTES.
           05 CT-NE10                      PIC X(04) VALUE 'NE10'.
           05 CT-MAPA                      PIC X(07) VALUE 'NEM1000'.
           05 CT-NE1C1001                  PIC X(08) VALUE 'NE1C1001'.
      *
           05 CT-NE11                      PIC X(04) VALUE 'NE11'.

      *****************************************************************
      *                    DEFINICION DE COPYBOOKS.                   *
      *****************************************************************
      * COPY DEL MAPA DE LA PANTALLA
       COPY NEM1000.

      * COPY SOPORTE BMS
       COPY DFHBMSCA.

      * COPY TOPORTE PARA TECLAS
       COPY DFHAID.

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
              MOVE CT-NE10                  TO WS-TRANSACCION
              PERFORM 1200-RETURN-TRANS
           END-IF.

       1000-INICIO-EXIT.
           EXIT.
      *****************************************************************
      *                     1100-SEND-MAP-ONLY                        *
      *****************************************************************
       1100-SEND-MAP-ONLY.

           MOVE LOW-VALUES                  TO NEM1000I

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
                TRANSID(WS-TRANSACCION)
                COMMAREA(WS-COMMAREA)
                LENGTH(WS-LARGO)
           END-EXEC.

      *****************************************************************
      *                       2000-PROCESO                            *
      *****************************************************************
       2000-PROCESO.

           EXEC CICS
                RECEIVE MAP(CT-MAPA)
                   INTO (NEM1000I)
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
               WHEN DFHPF2
                    PERFORM 2100-CONSULTA-EMP
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

           MOVE CT-NE11                     TO WS-TRANSACCION 
           PERFORM 1200-RETURN-TRANS.

      *****************************************************************
      *                          3000-FIN                             *
      *****************************************************************
       3000-FIN.

           EXEC CICS
                RETURN
           END-EXEC.

      *****************************************************************
      *                      9000-ERROR-MAPA                          *
      *****************************************************************
       9000-ERROR-MAPA.

           MOVE DFHBLINK                    TO MSGH
           MOVE 'ERROR EN MAPA'             TO MSGO

           EXEC CICS
                SEND MAP(CT-MAPA)
                ERASE
                FROM(NEM1000O)
                NOHANDLE
           END-EXEC

           PERFORM 3000-FIN.
      *****************************************************************
      *                      9000-ERROR-MAPA                          *
      *****************************************************************
       9100-OPCION-NO-VALIDA.

           MOVE DFHBLINK                    TO MSGH
           MOVE 'OPTION NO VALIDA'          TO MSGO

           EXEC CICS
                SEND MAP(CT-MAPA)
                ERASE
                FROM(NEM1000O )
                NOHANDLE
           END-EXEC.

       9100-OPCION-NO-VALIDA-EXIT.
           EXIT.


