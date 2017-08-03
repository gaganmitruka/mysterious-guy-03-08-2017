000100 IDENTIFICATION DIVISION.                                         00010001
000200 PROGRAM-ID. P01AP02.                                             00020001
000300 DATA DIVISION.                                                   00030001
000400 WORKING-STORAGE SECTION.                                         00040001
000500 01  WS-CA             PIC X(01).                                 00050002
000600 01  WS-CHOICE         PIC 9(01) VALUE ZERO.                      00060002
000700     88  VALID-CHOICE            VALUES 1 THRU 4.                 00070002
000800 01  WS-CHOICE-X  REDEFINES  WS-CHOICE                            00080002
000900                       PIC X(01).                                 00090002
001000 01  WS-DATE-TIME      PIC S9(15) COMP-3 VALUE ZERO.              00100002
001100 01  WS-MESSAGE        PIC X(30)  VALUE                           00110002
001200     'END OF THE PROGRAM, BYE, BYE!!'.                            00120001
001300     COPY P01AS02.                                                00130001
001400     COPY DFHAID.                                                 00140001
001500 LINKAGE SECTION.                                                 00150001
001600 01  DFHCOMMAREA     PIC X(01).                                   00160001
001700 PROCEDURE DIVISION.                                              00170001
001800 MAIN-PARA.                                                       00180001
001900     IF EIBCALEN = ZERO                                           00190001
002000         PERFORM FIRST-PARA                                       00200001
002100     ELSE                                                         00210001
002200         PERFORM NEXT-PARA.                                       00220001
002300 END-PARA.                                                        00230001
002400     EXEC CICS RETURN                                             00240001
002500         TRANSID('P01B')                                          00250001
002600         COMMAREA(WS-CA)                                          00260001
002700     END-EXEC.                                                    00270001
002800 FIRST-PARA.                                                      00280001
002900     MOVE LOW-VALUES TO MENUMAPO                                  00290001
003000     PERFORM SEND-PARA.                                           00300002
003100 SEND-PARA.                                                       00310002
003200     PERFORM DATE-TIME-PARA.                                      00320002
003300     EXEC CICS SEND                                               00330001
003400         MAP('MENUMAP')                                           00340001
003500         MAPSET('P01AS02')                                        00350001
003600         FROM (MENUMAPO)                                          00360001
003700         ERASE                                                    00370001
003800     END-EXEC.                                                    00380001
003900 NEXT-PARA.                                                       00390001
004000     EVALUATE EIBAID                                              00400001
004100        WHEN DFHPF3                                               00410001
004200           EXEC CICS SEND TEXT                                    00420001
004300               FROM(WS-MESSAGE)                                   00430001
004400               ERASE                                              00440001
004500           END-EXEC                                               00450001
004600           EXEC CICS RETURN                                       00460001
004700           END-EXEC                                               00470001
004800        WHEN DFHENTER                                             00480001
004900           PERFORM PROCESS-PARA                                   00490001
005000        WHEN OTHER                                                00500001
005100           MOVE 'INVALID KEY PRESSED' TO MESSAGEO                 00510001
005200     END-EVALUATE                                                 00520001
005300     PERFORM SEND-PARA.                                           00530002
005400 PROCESS-PARA.                                                    00540001
005500`    PERFORM RECEIVE-MAP.                                         00550004
005600     MOVE CHOICEI TO WS-CHOICE-X                                  00560001
005700     IF VALID-CHOICE                                              00570003
005800        PERFORM TRANSFER-PARA                                     00580001
005900     ELSE                                                         00590001
006000        MOVE 'INVALID CHOICE' TO MESSAGEO                         00600001
006100     END-IF.                                                      00610001
006200 TRANSFER-PARA.                                                   00620001
006300     EVALUATE WS-CHOICE                                           00630001
006400        WHEN 1                                                    00640001
006500           EXEC CICS XCTL                                         00650001
006600                PROGRAM('P01AP01')                                00660001
006700           END-EXEC                                               00670001
006800*       WHEN 2                                                    00680001
006900*          EXEC CICS XCTL                                         00690001
007000*               PROGRAM('P01AP03')                                00700001
007100*          END-EXEC                                               00710001
007200*       WHEN 3                                                    00720001
007300*          EXEC CICS XCTL                                         00730001
007400*               PROGRAM('P01AP04')                                00740001
007500*          END-EXEC                                               00750001
007600*       WHEN 4                                                    00760001
007700*          EXEC CICS XCTL                                         00770001
007800*               PROGRAM('P01AP05')                                00780001
007900*          END-EXEC                                               00790001
008000        WHEN OTHER                                                00800001
008100           MOVE 'PROGRAM NOT YET READY' TO MESSAGEO               00810001
008200     END-EVALUATE.                                                00820001
008300 RECEIVE-MAP.                                                     00830004
008400     EXEC CICS RECEIVE                                            00840004
008500         MAP('MENUMAP')                                           00850004
008600         MAPSET('P01AS02')                                        00860004
008700         INTO(MENUMAPI)                                           00870004
008800     END-EXEC.                                                    00880004
008900 DATE-TIME-PARA.                                                  00890002
009000     EXEC CICS ASKTIME                                            00900002
009100          ABSTIME(WS-DATE-TIME)                                   00910002
009200     END-EXEC.                                                    00920002
009300     EXEC CICS FORMATTIME                                         00930002
009400          ABSTIME(WS-DATE-TIME)                                   00940002
009500          DDMMYYYY(SYSDATEO)                                      00950002
009600          DATESEP                                                 00960002
009700          TIME(SYSTIMEO)                                          00970002
009800          TIMESEP                                                 00980002
009900     END-EXEC.                                                    00990002
