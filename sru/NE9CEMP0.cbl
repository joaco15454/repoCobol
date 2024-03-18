
      *****************************************************************
      *                                                               *
      *          I D E N T I F I C A T I O N  D I V I S I O N         *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  NE9CEMP0.
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
      *                    DEFINICION DE CONSTANTES                   *
      *****************************************************************
       01 SW-SWITCHES.

           05 SW-SQLCODE                 PIC S9(9) COMP.
              88 SQLCODE-88-OK                           VALUE 0.
              88 SQLCODE-88-NOTFND                       VALUE +100.
              88 SQLCODE-88-DUPLICATED                   VALUE -811.

      *****************************************************************
      *                    DEFINICION DE CONSTANTES                   *
      *****************************************************************
       01  CT-CONSTANTES.
           05 CT-RUTINA                  PIC X(08) VALUE 'NE9CEMP0'.
           05 CT-CAMPO-NUMEMP            PIC X(08) VALUE 'NUM EMPL'.
           05 CT-TABLA-EMP               PIC X(03) VALUE 'EMP'.
           05 CT-OPCION                  PIC X(06) VALUE 'OPCION'.
           05 CT-EMPNO                   PIC X(05) VALUE 'EMPNO'.
           05 CT-FIRST-NAME              PIC X(10) VALUE 'FIRST NAME'.
           05 CT-LAST-NAME               PIC X(09) VALUE 'LAST NAME'.
           05 CT-WORKDEPT                PIC X(08) VALUE 'WORKDEPT'.
           05 CT-PHONENO                 PIC X(07) VALUE 'PHONENO'.
           05 CT-HIREDATE                PIC X(08) VALUE 'HIREDATE'.
           05 CT-JOB                     PIC X(03) VALUE 'JOB'.
           05 CT-EDLEVEL                 PIC X(07) VALUE 'EDLEVEL'.
           05 CT-SEX                     PIC X(03) VALUE 'SEX'.
           05 CT-BIRTHDATE               PIC X(09) VALUE 'BIRTHDATE'.
           05 CT-SALARY                  PIC X(07) VALUE 'SALARY'.
           05 CT-BONUS                   PIC X(05) VALUE 'BONUS'.
           05 CT-COMM                    PIC X(04) VALUE 'COMM'.

      *****************************************************************
      *                     DEFINICION DE VARIABLES.                  *
      *****************************************************************
       01  WS-VARIABLE.
           05 WS-CONTADOR                PIC S9(05)V9(02) COMP-3.

       01  MA-AVISOS.
           05 MA-YA-EXISTE               PIC X(07) VALUE 'NEA0001'.
           05 MA-NO-EXISTE               PIC X(07) VALUE 'NEA0002'.

       01  ME-MENSAJES.
           05 ME-CAMPO-OBLIGATORIO       PIC X(07) VALUE 'NEE2001'.
           05 ME-REG-DUPLICADO           PIC X(07) VALUE 'NEE2010'.
           05 ME-OPCION-INVALIDA         PIC X(07) VALUE 'NEE2100'.

      *****************************************************************
      *                    DEFINICION DE DCLGEN Y SQL                 *
      *****************************************************************
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
              INCLUDE NEGTEMP
           END-EXEC.

      *****************************************************************
      *                     DEFINICION DE LINKAGE                     *
      *****************************************************************
       LINKAGE SECTION.
       01  WS-NEECEMP-01.
           COPY NEECEMP0.
       01  WS-NEECRET0-01.
           COPY NEECRET0.

      *****************************************************************
      *                                                               *
      *              P R O C E D U R E   D I V I S I O N              *
      *                                                               *
      *****************************************************************
       PROCEDURE DIVISION USING WS-NEECEMP-01 WS-NEECRET0-01.

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
      *                         1000-INICIO                           *
      *****************************************************************
       1000-INICIO.

           PERFORM 1100-INICIALIZA-VARIABLES
              THRU 1100-INICIALIZA-VARIABLES-EXIT

           PERFORM 1200-VALIDA-OBLIGATORIOS
              THRU 1200-VALIDA-OBLIGATORIOS-EXIT.

      *****************************************************************
      *                        1000-INICIO-EXIT                       *
      *****************************************************************
       1000-INICIO-EXIT.
           EXIT.

      *****************************************************************
      *                   1100-INICIALIZA-VARIABLES                   *
      *****************************************************************
       1100-INICIALIZA-VARIABLES.

           INITIALIZE WS-NEECRET0-01
           MOVE ZEROES                      TO WS-CONTADOR
           SET        RET0-88-OK            TO TRUE.

       1100-INICIALIZA-VARIABLES-EXIT.
           EXIT.

      *****************************************************************
      *                  1200-VALIDA-CAMPOS-OBLIGATORIOS              *
      *****************************************************************
       1200-VALIDA-OBLIGATORIOS.

           IF DEP0-OPCION EQUAL SPACES OR LOW-VALUES

              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-OPCION                TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN

           END-IF

           IF DEP0-EMPNO EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-EMPNO                 TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO    TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-FIRSTNME EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-FIRST-NAME            TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-LASTNAME EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-LAST-NAME             TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

                 PERFORM 3000-FIN
           END-IF.

       1200-VALIDA-OBLIGATORIOS-EXIT.
           EXIT.

      *****************************************************************
      *                           2000-PROCESO                        *
      *****************************************************************
       2000-PROCESO.

           EVALUATE TRUE
               WHEN DEP0-88-CREATE
                    PERFORM 2100-CREATE-EMP
                       THRU 2100-CREATE-EMP-EXIT
               WHEN DEP0-88-READ
                    PERFORM 2200-READ-EMP
                       THRU 2200-READ-EMP-EXIT
               WHEN DEP0-88-UPDATE
                    PERFORM 2300-UPDATE-EMP
                       THRU 2300-UPDATE-EMP-EXIT
               WHEN DEP0-88-DELETE
                    PERFORM 2400-DELETE-EMP
                       THRU 2400-DELETE-EMP-EXIT
               WHEN OTHER
                    SET RET0-88-COD-ERROR      TO TRUE
                    MOVE CT-RUTINA             TO RET0-PROGRAMA
                    MOVE CT-OPCION             TO RET0-VAR1-ERROR
                    MOVE ME-OPCION-INVALIDA    TO RET0-COD-ERROR

                    PERFORM 3000-FIN

           END-EVALUATE.

      *****************************************************************
      *                         2000-PROCESO-EXIT                     *
      *****************************************************************
       2000-PROCESO-EXIT.
           EXIT.


      *****************************************************************
      *                        2100-CREATE-EMP                        *
      *                                                               *
      *    - VALIDA SI YA EXISTE EL REGISTROS                         *
      *    - VALIDA CAMPOS OBLIGATORIOS PARA LA OPCION                *
      *    - INSERTA REGISTRO EN LA TABLA DE EMPLEADOS                *
      *                                                               +
      *****************************************************************
       2100-CREATE-EMP.

           PERFORM 2110-VALIDA-CAMPOS-CREATE
              THRU 2110-VALIDA-CAMPOS-CREATE-EXIT

           PERFORM 9000-MOVER-CAMPOS
              THRU 9000-MOVER-CAMPOS-EXIT

           EXEC SQL
              INSERT INTO DSN81310.EMP
              (
                    EMPNO,
                    FIRSTNME,
                    MIDINIT,
                    LASTNAME,
                    WORKDEPT,
                    PHONENO,
                    HIREDATE,
                    JOB,
                    EDLEVEL,
                    SEX,
                    BIRTHDATE,
                    SALARY,
                    BONUS,
                    COMM
              )
              VALUES
              (
                   :DCLEMP-EMPNO,
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
              )
           END-EXEC

           MOVE SQLCA                       TO SW-SQLCODE

           EVALUATE TRUE
               WHEN SQLCODE-88-OK
                    CONTINUE
               WHEN SQLCODE-88-DUPLICATED
                    SET RET0-88-COD-ERROR   TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    MOVE ME-REG-DUPLICADO   TO RET0-COD-ERROR
                    MOVE DEP0-EMPNO         TO RET0-VAR1-ERROR
                    PERFORM 3000-FIN
               WHEN OTHER
                    SET RET0-88-ERR-DB2     TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    PERFORM 9800-ABEND-DB2
           END-EVALUATE.

       2100-CREATE-EMP-EXIT.
           EXIT.

      *****************************************************************
      *                    2210-VALIDA-CAMPOS-CREATE                  *
      *****************************************************************
       2110-VALIDA-CAMPOS-CREATE.

           IF DEP0-WORKDEPT EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-WORKDEPT              TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-PHONENO EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-PHONENO               TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-HIREDATE EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-HIREDATE              TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-JOB EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-JOB                   TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-EDLEVEL GREATER THAN ZEROES
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-EDLEVEL               TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-SEX EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-SEX                   TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-BIRTHDATE EQUAL SPACE OR LOW-VALUE
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-BIRTHDATE             TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-SALARY IS NOT NUMERIC
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-SALARY                TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-BONUS IS NOT NUMERIC
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-BONUS                 TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF

           IF DEP0-COMM IS NOT NUMERIC
              SET RET0-88-COD-ERROR         TO TRUE
              MOVE CT-RUTINA                TO RET0-PROGRAMA
              MOVE CT-BONUS                 TO RET0-VAR1-ERROR
              MOVE ME-CAMPO-OBLIGATORIO     TO RET0-COD-ERROR

              PERFORM 3000-FIN
           END-IF.

       2110-VALIDA-CAMPOS-CREATE-EXIT.
           EXIT.

      *****************************************************************
      *                        2200-READ-EMP                          *
      *****************************************************************
       2200-READ-EMP.

           MOVE DEP0-EMPNO                  TO DCLEMP-EMPNO

           EXEC SQL
              SELECT FIRSTNME,
                     MIDINIT,
                     LASTNAME,
                     WORKDEPT,
                     PHONENO,
                     HIREDATE,
                     JOB,
                     EDLEVEL,
                     SEX,
                     BIRTHDATE,
                     SALARY,
                     BONUS,
                     COMM
                INTO :DCLEMP-FIRSTNME,
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
                FROM DSN81310.EMP
               WHERE EMPNO = :DCLEMP-EMPNO
           END-EXEC

           MOVE SQLCA                       TO SW-SQLCODE

           EVALUATE TRUE
               WHEN SQLCODE-88-OK
                    CONTINUE
               WHEN SQLCODE-88-NOTFND
                    SET RET0-88-COD-AVISO   TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    MOVE MA-NO-EXISTE       TO RET0-COD-ERROR
                    PERFORM 3000-FIN
               WHEN SQLCODE-88-DUPLICATED
                    SET RET0-88-COD-ERROR   TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    MOVE ME-REG-DUPLICADO   TO RET0-COD-ERROR
                    PERFORM 3000-FIN
               WHEN OTHER
                    SET RET0-88-ERR-DB2     TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    PERFORM 9800-ABEND-DB2
           END-EVALUATE.

       2200-READ-EMP-EXIT.
           EXIT.

      *****************************************************************
      *                        2300-UPDATE-EMP                        *
      *****************************************************************
       2300-UPDATE-EMP.

           PERFORM 9000-MOVER-CAMPOS
              THRU 9000-MOVER-CAMPOS-EXIT

           EXEC SQL
              UPDATE DSN81310.EMP
                 SET FIRSTNME  = :DCLEMP-FIRSTNME,
                     MIDINIT   = :DCLEMP-MIDINIT,
                     LASTNAME  = :DCLEMP-LASTNAME,
                     WORKDEPT  = :DCLEMP-WORKDEPT,
                     PHONENO   = :DCLEMP-PHONENO,
                     HIREDATE  = :DCLEMP-HIREDATE,
                     JOB       = :DCLEMP-JOB,
                     EDLEVEL   = :DCLEMP-EDLEVEL,
                     SEX       = :DCLEMP-SEX,
                     BIRTHDATE = :DCLEMP-BIRTHDATE,
                     SALARY    = :DCLEMP-SALARY,
                     BONUS     = :DCLEMP-BONUS,
                     COMM      = :DCLEMP-COMM
               WHERE EMPNO = :DCLEMP-EMPNO
           END-EXEC

           MOVE SQLCA                       TO SW-SQLCODE

           EVALUATE TRUE
               WHEN SQLCODE-88-OK
                    CONTINUE
               WHEN SQLCODE-88-NOTFND
                    SET RET0-88-COD-AVISO   TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    MOVE MA-NO-EXISTE       TO RET0-COD-ERROR
                    MOVE DEP0-EMPNO         TO RET0-VAR1-ERROR
                    PERFORM 3000-FIN
               WHEN OTHER
                    SET RET0-88-ERR-DB2     TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    PERFORM 9800-ABEND-DB2
           END-EVALUATE.

       2300-UPDATE-EMP-EXIT.
           EXIT.

      *****************************************************************
      *                        2400-DELETE-EMP                        *
      *****************************************************************
       2400-DELETE-EMP.

           MOVE DEP0-EMPNO                  TO DCLEMP-EMPNO

           EXEC SQL
              DELETE FROM DSN81310.EMP
               WHERE EMPNO  = :DCLEMP-EMPNO
           END-EXEC

           MOVE SQLCA                       TO SW-SQLCODE

           EVALUATE TRUE
               WHEN SQLCODE-88-OK
                    CONTINUE
               WHEN SQLCODE-88-NOTFND
                    SET RET0-88-COD-AVISO   TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    MOVE MA-NO-EXISTE       TO RET0-COD-ERROR
                    PERFORM 3000-FIN
               WHEN OTHER
                    SET RET0-88-ERR-DB2     TO TRUE
                    MOVE CT-RUTINA          TO RET0-PROGRAMA
                    PERFORM 9800-ABEND-DB2
           END-EVALUATE.

       2400-DELETE-EMP-EXIT.
           EXIT.
      *****************************************************************
      *                           3000-FIN                            *
      *****************************************************************
       3000-FIN.

           GOBACK.

      *****************************************************************
      *                       9000-MOVER-CAMPOS                       *
      *****************************************************************
       9000-MOVER-CAMPOS.

           MOVE DEP0-EMPNO                  TO DCLEMP-EMPNO
           MOVE DEP0-FIRSTNME               TO DCLEMP-FIRSTNME
           MOVE DEP0-MIDINIT                TO DCLEMP-MIDINIT
           MOVE DEP0-LASTNAME               TO DCLEMP-LASTNAME
           MOVE DEP0-WORKDEPT               TO DCLEMP-WORKDEPT
           MOVE DEP0-PHONENO                TO DCLEMP-PHONENO
           MOVE DEP0-HIREDATE               TO DCLEMP-HIREDATE
           MOVE DEP0-JOB                    TO DCLEMP-JOB
           MOVE DEP0-EDLEVEL                TO DCLEMP-EDLEVEL
           MOVE DEP0-SEX                    TO DCLEMP-SEX
           MOVE DEP0-BIRTHDATE              TO DCLEMP-BIRTHDATE
           MOVE DEP0-SALARY                 TO DCLEMP-SALARY
           MOVE DEP0-BONUS                  TO DCLEMP-BONUS
           MOVE DEP0-COMM                   TO DCLEMP-COMM.

       9000-MOVER-CAMPOS-EXIT.
           EXIT.
      *****************************************************************
      *                          9800-ABEND-DB2                       *
      *****************************************************************
       9800-ABEND-DB2.

           MOVE SQLCAID                     TO RET0-SQLCAID
           MOVE SQLCODE                     TO RET0-SQLCODE
           MOVE SQLERRM                     TO RET0-SQLERRM
           MOVE CT-TABLA-EMP                TO RET0-TABLENAME

           GOBACK.

