RS      equ     P1.3
EN      equ     P1.2

org 0000h
	LJMP START

org 023H ; PONTEIRO DA INTERRUPCAO PARA CANAL SERIAL
	MOV A,SBUF ; REALIZA A LEITURA DO BYTE RECEBIDO
	CJNE A, #0Dh, escreve
	RETI
	
escreve:
	MOV 30h, A ; ESCREVE O VALOR NO ENDEREÇO 30H
	CLR RI ; RESETA RI PARA RECEBER NOVO BYTE
	SETB F0
	RETI

org 0040h

PALAVRAS:
DB "TESTE"
DB 00h

org 0100h
START:

main:
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
