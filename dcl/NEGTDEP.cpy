      ******************************************************************
      * DCLGEN TABLE(DSN81010.DEPT)                                    *
      *        LIBRARY(NEORIS1.DEV.DCLGEN(DEPDCL))                     *
      *        LANGUAGE(COBOL)                                         *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE NEOSB36.DEPT TABLE
           ( DEPTNO                         CHAR(3) NOT NULL,
             DEPTNAME                       VARCHAR(36) NOT NULL,
             MGRNO                          CHAR(6),
             ADMRDEPT                       CHAR(3) NOT NULL,
             LOCATION                       CHAR(16)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE DSN81010.DEPT                      *
      ******************************************************************
       01  DCLDEP.
           10 DCLDEP-DEPTNO                 PIC X(3).
           10 DCLDEP-DEPTNAME               PIC X(36).
           10 DCLDEP-MGRNO                  PIC X(6).
           10 DCLDEP-ADMRDEPT               PIC X(3).
           10 DCLDEP-LOCATION               PIC X(16).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 5       *
      * THE LENGHT OF RECORDS DESCRIGER IS 64                          *
      ******************************************************************