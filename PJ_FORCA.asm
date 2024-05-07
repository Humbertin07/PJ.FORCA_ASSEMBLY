RS      EQU     P1.3
EN      EQU     P1.2

ORG 0000h ; espaço para variáveis

ORG 0000h
    LJMP START ; está chamando a label START para iniciar o jogo

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

ORG 0080h
AOBA:
    DB "FORCA"
    DB 00h

PALAVRA:
    DB "TESTE"
    DB 00h

FRACASSO:
    DB "FRACASSO"
    DB 00h

VENCEDOR:
    DB "YOU WIN!"
    DB 00h

START:
    ACALL lcd_init ; está chamando a sub-rotina lcd-init para inicializar o LCD
    MOV SCON, #50H ;porta serial no modo 1 e habilita a recepção
    MOV PCON, #80h ;set o bit SMOD
    MOV TMOD, #20H ;CT1 no modo 2
    MOV TH1, #243 ;valor para a recarga
    MOV TL1, #243 ;valor para a primeira contagem
    MOV IE,#90H ; Habilita interrupção serial
    SETB TR1 ; liga o contador/temporizador 1 
    MOV R5, #05h ; inicia R5 com o valor 05h
    MOV R7, #08h ; inicia R& com o valor 08h
    MOV A, #05h ; está mostrando aonde será o início da impressão da string no lcd para logo em seguida o cursor ser posicionado
    ACALL posicionaCursor ; chama a sub-rotina posicionaCursor para que a impressão no lcd seja feita na posição correta
    MOV DPTR,#AOBA ; está movendo a palavra armazenada em AOBA para DPTR         
    ACALL escreveStringROM ; chama a sub-rotina escreveStringROM para que haja a impressão da string armazenada e chamada anteriormente
    ACALL clearDisplay ; limpa o display 
    ; daqui pra baixo está sendo impresso o número da pontuação
    MOV A, #4Fh ; está mostrando aonde será a impressão da string no lcd para logo em seguida o cursor ser posicionado
    ACALL posicionaCursor ; posiciona o cursor para realizar a impressão
    MOV 70h, R7 ; chama o número armazenado em R7, e movimenta para 70h
    MOV A , 70h ; movimenta o valor de 70h para A
    ADD A, #30h ; adiciona 30h no valor armazenado em A
    ACALL sendCharacter ; envia o caracter e faz a impressão
    MOV R4, #40h ; inicializa R4 com o valor de 40h indicando o início da segunda linha do LCD
    JMP $    

escreveStringROM:
    MOV R1, #00h 

loop:
    MOV A, R1 ; Move o conteúdo de R1 para A
    MOVC A, @A + DPTR ;  ; carrega o caractere da palavra
    JZ  finish  ; se A for 0, o programa encerra o Loop
    ACALL sendCharacter ; chama a sub-rotina sendCharacter 
    INC R1 ; incremente R1
    JMP loop ; Pula para o início do loop
finish:
    RET

; aqui inicia-se a comparação das letras inputadas com as letras armazenadas
comparaLetra:
    MOV DPTR, #PALAVRA ; aponta DPTR para o início da palavra 
    MOV R1, #00h ; inicializa o índice
    MOV R3, #00h ; R3 indica que se houve erro de letra

loopComparacao:
    MOV A, R1 ; 
    MOVC A, @A + DPTR ; carrega o caractere da palavra
    JZ  fimComparacao ; se for zero, chegamos ao fim da palavra
    CJNE A, 30h, verificaProximo ; compara o caractere com o valor em 30h
    ; se eles são iguais, a letra está na palavra
    ; exibe a letra na primeira linha do LCD
    MOV A, R1
    ACALL posicionaCursor
    MOV A, 30h
    ACALL sendCharacter
    MOV R3, #0FFh ; movimenta a o valor #0FFh para R3 para que depois seja comparado e liberado a passagem da parte das letras incorretas, assim entendendo que a letra imputada estava correta.
    DEC  R5; decrementa e R5 até chegar em 0
    
    CJNE R5, #00h, verificaProximo ; se o valor de R5 chegar em 0, ele não pula para verificaProximo e entra na linha de código abaixo
; nela o display é limpo, o cursor é posiconado em #04h e a palavra armazenada em #VENCEDOR é impressa e lgoo após o o jogo é finlaizado
    ACALL clearDisplay
    MOV A, #04h
    ACALL posicionaCursor
    MOV DPTR,#VENCEDOR        
    ACALL escreveStringROM
    ACALL clearDisplay
    SJMP $

verificaProximo:
    INC R1 ; incrementa R1
    JMP loopComparacao ; pula de volta para que a comparação da próxima letra recebida seja feita

fimComparacao:
    CJNE R3, #00h, fimDoFim ; se o valor encontrado em R3 não for #00h, 
                            ; o código automaticamente pula para a sub-rotina fimDoFim, caso contrário, 
                            ; entra na linha de código abaixo apontando que a letra está incorreta. 
                            ; Por isso que em algumas linhas acima, o código armazenou #0FFh em R3, pois seria usado aqui.
    ; a letra não está na palavra
    ; exibe a letra na segunda linha do LCD
    MOV A, R4 ; pega a posição atual na segunda linha
    ACALL posicionaCursor
    MOV A, 30h
    ACALL sendCharacter
    INC R4 ; incrementa a posição na segunda linha
    DEC R7 ; decrementa e reimprime a pontuação até chegar em 0
    MOV A, #4Fh
    ACALL posicionaCursor
    MOV 70h, R7
    MOV A , 70h
    ADD A, #30h
    ACALL sendCharacter

    CJNE R7, #00h, fimDoFim ; se o valor de R7 chegar em 0, ele não pula para fimDoFim e entra na linha de código abaixo
; nela o display é limpo, o cursor é posiconado em #04h e a palavra armazenada em #FRACASSO é impressa e logo após o o jogo é finalizado
    ACALL clearDisplay
    MOV A, #04h
    ACALL posicionaCursor
    MOV DPTR,#FRACASSO        
    ACALL escreveStringROM
    ACALL clearDisplay
    SJMP $

fimDoFim:  
    RET ; retorna da sub-rotina para esperar a próxima letra

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


