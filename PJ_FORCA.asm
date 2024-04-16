ORG 0H

MOV P1, #0H

CALL AcenderSegmentos

SJMP $

AcenderSegmentos:
    MOV P1, #0x3F
    RET

END

ORG 000h

quantidade_palavras equ 5
tamanho_total_palavras equ 10

palavras: DB "BANANA", 0
          DB "ABACAXI", 0
          DB "MORANGO", 0
          DB "UVA", 0    
          DB "LARANJA", 0


MAIN:
      RET

END
