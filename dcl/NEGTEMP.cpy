      ******************************************************************
      * DCLGEN TABLE(DSN81010.EMP)                                     *
      *        LANGUAGE(COBOL)                                         *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE NEOSB36.EMP TABLE
           ( EMPNO                          CHAR(6) NOT NULL,
             FIRSTNME                       VARCHAR(12) NOT NULL,
             MIDINIT                        CHAR(1) NOT NULL,
             LASTNAME                       VARCHAR(15) NOT NULL,
             WORKDEPT                       CHAR(3),
             PHONENO                        CHAR(4),
             HIREDATE                       DATE,
             JOB                            CHAR(8),
             EDLEVEL                        SMALLINT,
             SEX                            CHAR(1),
             BIRTHDATE                      DATE,
             SALARY                         DECIMAL(9, 2),
             BONUS                          DECIMAL(9, 2),
             COMM                           DECIMAL(9, 2)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE DSN81010.EMP                       *
      ******************************************************************
       01  DCLEMP.
           10 DCLEMP-EMPNO                  PIC X(6).
           10 DCLEMP-FIRSTNME               PIC X(12).
           10 DCLEMP-MIDINIT                PIC X(1).
           10 DCLEMP-LASTNAME               PIC X(15).
           10 DCLEMP-WORKDEPT               PIC X(3).
           10 DCLEMP-PHONENO                PIC X(4).
           10 DCLEMP-HIREDATE               PIC X(10).
           10 DCLEMP-JOB                    PIC X(8).
           10 DCLEMP-EDLEVEL                PIC S9(4) USAGE COMP.
           10 DCLEMP-SEX                    PIC X(1).
           10 DCLEMP-BIRTHDATE              PIC X(10).
           10 DCLEMP-SALARY                 PIC S9(7)V9(2) USAGE COMP-3.
           10 DCLEMP-BONUS                  PIC S9(7)V9(2) USAGE COMP-3.
           10 DCLEMP-COMM                   PIC S9(7)V9(2) USAGE COMP-3.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 14      *
      * THE LENGHT OF RECORDS DESCRIGER IS 90                          *
      ******************************************************************