RS      EQU     P1.3
EN      EQU     P1.2

ORG 0000h ; espaço para variáveis
posicaoLinha2: DB 00h ; posição atual na segunda linha

ORG 0000h
    LJMP START

ORG 023H ; PONTEIRO DA INTERRUPCAO PARA CANAL SERIAL
    MOV A,SBUF ; REALIZA A LEITURA DO BYTE RECEBIDO
    MOV @R0, A
    CLR RI
    INC R0
    CJNE A, #0Dh, escreve
    RETI

escreve:
    MOV 30h, A ; ESCREVE O VALOR NO ENDEREÇO 30H
    ;CLR RI ; RESETA RI PARA RECEBER NOVO BYTE
    SETB F0
    ACALL comparaLetra ; Adicionado chamada para comparaLetra aqui
    RETI

ORG 0040h

PALAVRAS:
    DB "TESTE"
    DB 00h

ORG 0100h
START:
    MOV P2, #0xFF ; Inicia o jogo com todos os LEDs acesos
    ACALL lcd_init
    MOV A, #05h
    ACALL posicionaCursor
    MOV DPTR,#PALAVRAS           
    ACALL escreveStringROM
    ACALL clearDisplay
    MOV SCON, #50H ;porta serial no modo 1 e habilita a recepção
    MOV PCON, #80h ;set o bit SMOD
    MOV TMOD, #20H ;CT1 no modo 2
    MOV TH1, #243 ;valor para a recarga
    MOV TL1, #243 ;valor para a primeira contagem
    MOV IE,#90H ; Habilita interrupção serial
    SETB TR1 ;liga o contador/temporizador 1 
    JNB F0, $
    MOV A, #45h
    ACALL posicionaCursor
    MOV A, 30h
    ACALL sendCharacter
    JMP $

escreveStringROM:
    MOV R1, #00h  

loop:
    MOV A, R1
    MOVC A, @A + DPTR
    JZ  finish  
    ACALL sendCharacter  
    INC R1
    JMP loop
finish:
    RET

comparaLetra:
    MOV DPTR, #PALAVRAS ; aponta DPTR para o início da palavra
    MOV R1, #00h ; inicializa o índice

loopComparacao:
    MOV A, R1
    MOVC A, @A + DPTR ; carrega o caractere da palavra
    JZ  fimComparacao ; se for zero, chegamos ao fim da palavra
    CJNE A, 30h, letraIncorreta ; compara o caractere com o valor em 30h

    ; se eles são iguais, a letra está na palavra
    ; exibe a letra na primeira linha do LCD
    MOV A, R1
    ACALL posicionaCursor
    MOV A, 30h
    ACALL sendCharacter
    INC R1
    JMP loopComparacao

letraIncorreta:
    ; a letra não está na palavra
    ; exibe a letra na segunda linha do LCD
    MOV A, posicaoLinha2 ; pega a posição atual na segunda linha
    ADD A, #40h ; adiciona o endereço base da segunda linha
    ACALL posicionaCursorLinha2
    MOV A, 30h
    ACALL sendCharacter
    DEC P2 ; decrementa o display 3
    INC posicaoLinha2 ; incrementa a posição na segunda linha
    INC R1
    JMP loopComparacao

fimComparacao:
    ; aqui você pode lidar com o caso em que a letra não está na palavra
    RET


posicionaCursorLinha2:
    CLR RS    
    SETB P1.7            
    MOV A, posicaoLinha2 ; usa a variável posicaoLinha2
    ADD A, #40h ; adiciona o endereço base da segunda linha
    ACALL posicionaCursor
    RET

lcd_init:

    CLR RS        
    
    CLR P1.7        
    CLR P1.6        
    SETB P1.5        
    CLR P1.4    

    SETB EN        
    CLR EN        

    CALL delay    
    
    SETB EN    
    CLR EN            
                    

    SETB P1.7        

    SETB EN        
    CLR EN            
                
    CALL delay    

    CLR P1.7        
    CLR P1.6        
    CLR P1.5        
    CLR P1.4        

    SETB EN        
    CLR EN        

    SETB P1.6        
    SETB P1.5        

    SETB EN        
    CLR EN        

    CALL delay        

    CLR P1.7        
    CLR P1.6        
    CLR P1.5        
    CLR P1.4        

    SETB EN        
    CLR EN        

    SETB P1.7        
    SETB P1.6        
    SETB P1.5    
    SETB P1.4        

    SETB EN        
    CLR EN        

    CALL delay        
    RET


sendCharacter:
    SETB RS          
    MOV C, ACC.7        
    MOV P1.7, C            
    MOV C, ACC.6        
    MOV P1.6, C            
    MOV C, ACC.5        
    MOV P1.5, C            
    MOV C, ACC.4        
    MOV P1.4, C            
    SETB EN            
    CLR EN        

    MOV C, ACC.3        
    MOV P1.7, C            
    MOV C, ACC.2        
    MOV P1.6, C            
    MOV C, ACC.1        
    MOV P1.5, C    
    MOV C, ACC.0        
    MOV P1.4, C            

    SETB EN            
    CLR EN            

    CALL delay        
    CALL delay            
    RET

posicionaCursor:
    CLR RS    
    SETB P1.7            
    MOV C, ACC.6    
    MOV P1.6, C            
    MOV C, ACC.5        
    MOV P1.5, C            
    MOV C, ACC.4        
    MOV P1.4, C            

    SETB EN            
    CLR EN            

    MOV C, ACC.3        
    MOV P1.7, C            
    MOV C, ACC.2        
    MOV P1.6, C            
    MOV C, ACC.1        
    MOV P1.5, C            
    MOV C, ACC.0        
    MOV P1.4, C            

    SETB EN            
    CLR EN            

    CALL delay            
    CALL delay            
    RET

retornaCursor:
    CLR RS    
    CLR P1.7        
    CLR P1.6        
    CLR P1.5        
    CLR P1.4    

    SETB EN        
    CLR EN        

    CLR P1.7        
    CLR P1.6        
    SETB P1.5        
    SETB P1.4        

    SETB EN        
    CLR EN        

    CALL delay        
    RET



clearDisplay:
    CLR RS    
    CLR P1.7        
    CLR P1.6        
    CLR P1.5        
    CLR P1.4        

    SETB EN        
    CLR EN        

    CLR P1.7        
    CLR P1.6        
    CLR P1.5        
    SETB P1.4        

    SETB EN        
    CLR EN        

    MOV R6, #40
    rotC:
    CALL delay        
    DJNZ R6, rotC
    RET

delay:
    MOV R0, #50
    DJNZ R0, $
    RET


