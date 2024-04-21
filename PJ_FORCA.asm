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
-------------------------------------------------------------
;Nesse trecho em diante, temos um código funcional...

; Define pinos do LCD
RS      equ     P1.3
EN      equ     P1.2

org     000h
ljmp    start

; Rotina de interrupção do UART
org     023h
MOV     A, SBUF      ; Recebe o caractere via UART
MOV     30h, A       ; Armazena o caractere na posição 30h
CLR     RI           ; Limpa a flag de recepção
RETI

start:
org     200h
MOV     SCON, #50h   ; Modo 1: 8-bit UART
MOV     PCON, #80h   ; SMOD = 1 para dobrar a taxa de baud
MOV     TMOD, #20h   ; Timer 1, modo 2
MOV     TH1, #0FDh   ; Baud rate de 9600 com SMOD = 1
MOV     TL1, #0FDh
MOV     IE, #90h     ; Habilita interrupção serial
SETB    TR1          ; Inicia Timer 1
ACALL   lcd_init     ; Inicializa LCD

; Armazena a palavra "HELLO" na memória interna
MOV     20h, #'H'
MOV     21h, #'E'
MOV     22h, #'L'
MOV     23h, #'L'
MOV     24h, #'O'
MOV     25h, #0       ; Terminador nulo

; Espera e processa caracteres recebidos
wait_for_char:
JNB     RI, wait_for_char ; Espera receber um caractere
MOV     A, SBUF         ; Lê o caractere recebido
MOV     30h, A          ; Armazena em 30h
CLR     RI              ; Limpa a flag de recepção

; Configura o ponteiro para a palavra
MOV     R0, #20h

; Procura o caractere na palavra
compare_chars:
MOV     A, @R0          ; Carrega um caractere da palavra
CJNE    A, #0, check_match ; Se não é o terminador nulo, continua
SJMP    display_no      ; Se é o terminador nulo, mostra "não"
check_match:
CJNE    A, 30h, next_char ; Compara com o caractere armazenado em 30h
ACALL   display_yes     ; Se igual, mostra "sim"
SJMP    wait_for_char   ; Volta para esperar o próximo caractere
next_char:
INC     R0              ; Incrementa o ponteiro da palavra
SJMP    compare_chars   ; Continua a comparação

; Funções do LCD
lcd_init:
; Assume que os comandos são enviados via P1.4-P1.7
    MOV     A, #0x03
    ACALL   send_lcd_cmd
    ACALL   send_lcd_cmd
    MOV     A, #0x02
    ACALL   send_lcd_cmd
    MOV     A, #0x28       ; LCD 4-bit, 2 linha
    ACALL   send_lcd_cmd
    MOV     A, #0x0C       ; Display ON, Cursor OFF
    ACALL   send_lcd_cmd
    MOV     A, #0x06       ; Entry mode set
    ACALL   send_lcd_cmd
    MOV     A, #0x01       ; Clear display
    ACALL   send_lcd_cmd
    RET

send_lcd_cmd:
    CLR     RS             ; Envia comando
    ACALL   send_nibble
    SWAP    A
    ACALL   send_nibble
    ACALL   lcd_delay
    RET

send_lcd_data:
    SETB    RS             ; Envia dados
    ACALL   send_nibble
    SWAP    A
    ACALL   send_nibble
    ACALL   lcd_delay
    RET

send_nibble:
    MOV     C, ACC.7
    MOV     P1.7, C
    MOV     C, ACC.6
    MOV     P1.6, C
    MOV     C, ACC.5
    MOV     P1.5, C
    MOV     C, ACC.4
    MOV     P1.4, C
    SETB    EN
    NOP
    NOP
    CLR     EN
    RET

lcd_delay:
    MOV     R2, #20
wait_delay:
    DJNZ    R2, wait_delay
    RET

display_yes:
    MOV     A, #'Y'
    ACALL   send_lcd_data
    MOV     A, #'e'
    ACALL   send_lcd_data
    MOV     A, #'s'
    ACALL   send_lcd_data
    RET

display_no:
    MOV     A, #'N'
    ACALL   send_lcd_data
    MOV     A, #'o'
    ACALL   send_lcd_data
    RET
