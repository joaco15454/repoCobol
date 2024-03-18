      ******************************************************************
      *                                                                *
      * NOMBRE DEL OBJETO:  NEECRET0                                   *
      *                                                                *
      * DESCRIPCION:  AREA DE COMUNICACION PARA INFORMACION DE ERRORES *
      *                                                                *
      * -------------------------------------------------------------- *
      *                                                                *
      *           LONGITUD : 703 POSICIONES.                           *
      *           PREFIJO  : RET0.                                     *
      *                                                                *
      ******************************************************************
                                                                        
           02  NEECRET0.                                                
                                                                        
               05  RET0-COD-RET                      PIC X(02).         
                   88 RET0-88-OK            VALUE '00'.                 
                   88 RET0-88-COD-AVISO     VALUE '10'.                 
                   88 RET0-88-COD-ERROR     VALUE '20'.                 
                   88 RET0-88-ERR-DB2       VALUE '98'.                 
                   88 RET0-88-ERR-CICS      VALUE '99'.                 
                                                                        
               05  RET0-PROGRAMA                     PIC  X(08).        
                                                                        
               05  RET0-COD-ERROR                    PIC  X(07).        
                                                                        
               05  RET0-VAR1-ERROR                   PIC  X(20).        
                                                                        
               05  RET0-VAR2-ERROR                   PIC  X(20).        
                                                                        
               05  RET0-DB2-LOG.                                        
                   10  RET0-DATOS-DB2.                                  
                       15  RET0-SQLCAID              PIC  X(08).        
                       15  RET0-SQLCABC              PIC  S9(09) COMP-3.
                       15  RET0-SQLCODE              PIC  S9(09) COMP-3.
                       15  RET0-SQLERRM.                                
                           20  RET0-SQLERRML         PIC  S9(09) COMP-3.
                           20  RET0-SQLERRMC         PIC  X(70).        
                                                                        
                       15  RET0-SQLERRP              PIC  X(08).        
                                                                        
                       15  RET0-SQLERRD              PIC  S9(09) COMP-3.
                                                                        
                       15  RET0-SQLWARN.                                
                           20  RET0-SQLWARN0         PIC  X(01).        
                           20  RET0-SQLWARN1         PIC  X(01).        
                           20  RET0-SQLWARN2         PIC  X(01).        
                           20  RET0-SQLWARN3         PIC  X(01).        
                           20  RET0-SQLWARN4         PIC  X(01).        
                           20  RET0-SQLWARN5         PIC  X(01).        
                           20  RET0-SQLWARN6         PIC  X(01).        
                           20  RET0-SQLWARN7         PIC  X(01).        
                                                                        
                       15  RET0-SQLEXT.                                 
                           20  RET0-SQLWARN8         PIC  X(01).        
                           20  RET0-SQLWARN9         PIC  X(01).        
                           20  RET0-SQLWARNA         PIC  X(01).        
                           20  RET0-SQLSTATE         PIC  X(05).        
                                                                        
                   10  RET0-TABLENAME                PIC  X(08).        
                                                                        
               05  RET0-CICS-LOG.                                       
                   10  RET0-EIBRCODE                 PIC  X(06).        
                   10  RET0-EIBFN                    PIC  X(02).        
                   10  RET0-EIBRSRCE                 PIC  X(08).        
                                                                        
               05  RET0-COD-AVISO1                   PIC  X(07).        
               05  RET0-VAR1-AVISO1                  PIC  X(20).        
               05  RET0-VAR2-AVISO1                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO2                   PIC  X(07).        
               05  RET0-VAR1-AVISO2                  PIC  X(20).        
               05  RET0-VAR2-AVISO2                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO3                   PIC  X(07).        
               05  RET0-VAR1-AVISO3                  PIC  X(20).        
               05  RET0-VAR2-AVISO3                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO4                   PIC  X(07).        
               05  RET0-VAR1-AVISO4                  PIC  X(20).        
               05  RET0-VAR2-AVISO4                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO5                   PIC  X(07).        
               05  RET0-VAR1-AVISO5                  PIC  X(20).        
               05  RET0-VAR2-AVISO5                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO6                   PIC  X(07).        
               05  RET0-VAR1-AVISO6                  PIC  X(20).        
               05  RET0-VAR2-AVISO6                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO7                   PIC  X(07).        
               05  RET0-VAR1-AVISO7                  PIC  X(20).        
               05  RET0-VAR2-AVISO7                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO8                   PIC  X(07).        
               05  RET0-VAR1-AVISO8                  PIC  X(20).        
               05  RET0-VAR2-AVISO8                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO9                   PIC  X(07).        
               05  RET0-VAR1-AVISO9                  PIC  X(20).        
               05  RET0-VAR2-AVISO9                  PIC  X(20).        
                                                                        
               05  RET0-COD-AVISO10                  PIC  X(07).        
               05  RET0-VAR1-AVISO10                 PIC  X(20).        
               05  RET0-VAR2-AVISO10                 PIC  X(20).        
                                                                        
               05  RET0-DESERROR                     PIC  X(30).        