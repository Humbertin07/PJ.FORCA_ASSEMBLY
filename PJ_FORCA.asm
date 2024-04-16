ORG 0H

MOV P1, #0H

CALL AcenderSegmentos

SJMP $

AcenderSegmentos:
    MOV P1, #0x3F
    RET

END
