;************************************************
; PRZERWANIA
;************************************************

LED	EQU P1.7
GLOSNIK EQU P1.5

;********* Ustawienie TIMERÓW *********

						;TIMER 0
T0_G EQU 0 				;GATE
T0_C EQU 0 				;COUNTER/-TIMER
T0_M EQU 1 				;MODE (0..3)
TIM0 EQU T0_M+T0_C*4+T0_G*8
						;TIMER 1
T1_G EQU 0 				;GATE
T1_C EQU 0 				;COUNTER/-TIMER
T1_M EQU 1 				;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8
TMOD_SET EQU TIM0+TIM1*16
						;10[ms] = 10 000[uS]*(11.0592[MHz]/12) = 9216 cykli = 36 * 256
TH0_SET EQU 256-36
TL0_SET EQU 0

TH1_SET EQU 256-180
TL1_SET EQU 0

;**************************************

	LJMP START

;********* Przerwanie Timer 0 *********
	
	ORG 0BH
	MOV TH0,#TH0_SET 	;TH0 na 10ms
	DJNZ R7,NO_1MS 		;czy minęło 10 ms(sprawdzane co 10ms)
	LCALL STOPER 		;wykonywane co 10 ms
	
NO_1MS:
	RETI
	
;**************************************

;********* Przerwanie Timer 1 *********

	ORG 1BH
	MOV TH1,#TH1_SET 	;TH1 na 50ms
	DJNZ R6,NO_500MS 	;czy minęło 500 ms(sprawdzane co 50ms)
	LCALL BUZZER 		;wykonywane co 500 ms
	
NO_500MS:
	RETI
	
;**************************************

	ORG 100H
START:
	LCALL LCD_INIT
	MOV R1, #0			;zeruj sekundy
	MOV R2, #0			;zeruj milisekundy
	MOV R3, #0			;zeruj sprawdzanie 10sek
	MOV TMOD,#TMOD_SET 	;Timer 0 liczy czas
	MOV TH0,#TH0_SET 	;Timer 0 na 10ms
	MOV TL0,#TL0_SET
	MOV TH1,#TH1_SET 	;Timer 1 na 50ms
	MOV TL1,#TL1_SET
	SETB EA 			;włącz zezwolenie ogólne
						;na przerwania
	SETB ET0 			;włącz zezwolenie na
						;przerwanie od Timera 0
	SETB ET1 			;włącz zezwolenie na
						;przerwanie od Timera 1

	MOV R7,#1			;zainicjuj R7: 1*10ms=10ms
	MOV R6,#10			;zainicjuj R6: 10*50ms=500ms
	SETB TR0 			;start Timera 0
	SETB TR1 			;start Timera 1
STARTORSTOP:
	LCALL WAIT_ENTER_NW ;czekaj na enter
	CPL TR0
	CPL TR1
	SJMP STARTORSTOP
	SJMP $ 				;koniec pracy
						;programu głównego
STOPER:
	MOV R7,#1			;ustaw ponownie R7:1*10ms=10ms

	MOV A, R2
	CJNE A, #100, LICZMS
	MOV R2, #0

	MOV A, R1
	CJNE A, #100, LICZS
	MOV R1, #0

	RET 				;powrót z podprogramu
	NOP
BUZZER:
	MOV R6,#10			;ustaw ponownie R6:10*50ms=500ms

						;sekcja drutowania w programie 💀

	SETB GLOSNIK		;wylacz glosnik
	INC R3				;zwieksz R3
	MOV A, R3	
	CJNE A, #20, ROBNIC
	CLR GLOSNIK			;odpal syrene
	MOV R3, #0			;zeruj R3

	RET 				;powrót z podprogramu
	NOP
POKAZCZAS:
	LCALL LCD_CLR		;wyczysc ekran
	MOV A, R1			;wyswietl sekundy
	LCALL BCD
	MOV A, #','			;wyswietl ,
	LCALL WRITE_DATA
	MOV A, R2			;wyswietl milisekundy
	LCALL BCD
ROBNIC:
	RET
BCD:
	MOV B,#10
	DIV AB
	SWAP A
	ORL A, B
	LCALL WRITE_HEX
	RET
LICZMS:
	LCALL POKAZCZAS
	INC R2
	RET
LICZS:
	LCALL POKAZCZAS
	INC R1
	RET
STOP:
	LJMP STOP
	NOP