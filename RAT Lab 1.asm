;-------------------------------------------------------------------------------
;
; Authors: Conor Murphy, Lucy Bowen
;
;-------------------------------------------------------------------------------
.EQU 		MAX_FIB 	= 	0X0D

.DEF		INPUT		= 	R0
.DEF		OPTION		= 	R1
.DEF		ONE		= 	R30
.DEF		TWO		=  	R31
.DEF		MAX		= 	R29
	
.DEF 		DIVISOR		= 	R10
.DEF		QUOTIENT	= 	R11
.DEF		REMAINDER	= 	R12
.DEF		DIVIDEND	= 	R13

.CSEG
.ORG 0X01

begin:		IN 		R0,	0X01 	; in port 0x01
			MOV 	ONE, 0X01	; output value 1
			MOV 	TWO, 0X02	; output value 2
			MOV 	MAX, 0XFF	; output value 255
;--------------------------------------------------------------------------------
opselect:	IN		R1, 0X02 	; option select
			CMP 	R1, 0X00	; if 0...go to end
			BREQ	end			; 
			CMP 	R1, 0X01	; if 1...go to determine if even/odd
			BREQ 	odd			; 
			CMP		R1, 0X02	; if 2...go to determine if prime
			BREQ	prime		
			CMP 	R1, 0X03	; if 3...go to perfect
			BREQ	perfect
			CMP		R1, 0X04	; if 4...go to fibonacci
			BREQ 	fibonacci
			CMP 	R1, 0X05	; if 5...go to reverse
			BREQ 	reversed
			CMP 	R1, 0X06	; if 6...go to divide
			BREQ 	divremain
			CMP 	R1, 0X07	; if 7...go to our operation
			BREQ	new_op
			BRN 	opselect		; invalid option; pick new
;--------------------------------------------------------------------------------
odd:		TEST	R0, 0X01	; OPTION 1
			BRNE	printodd	; print odd branch, otherwise print even
			OUT		R31, 0x01
			BRN 	opselect
printodd:	OUT		R30, 0x02
			BRN 	opselect
;--------------------------------------------------------------------------------
prime:		CMP 	R0, 0X00				; 0 check
			BREQ	notprime				; if 0, print not prime
			CMP 	R0, 0X01
			BREQ	notprime				; if 1, not prime for some reason
			MOV 	DIVISOR, 0X02				; set divisor to 2 to check prime
			MOV		DIVIDEND, R0				; set up to halve R0
			CALL 	division
			MOV 	R3, QUOTIENT					; half of R0
primeloop:	CMP		DIVISOR, R3					; if i (divisor) <= input/2...
			BRCC 	isprime
			CALL	division
			CMP 	REMAINDER, 0X00
			BREQ	notprime
			ADD		DIVISOR, 0X01
			BRN 	primeloop
isprime:	OUT 	R30, 0X02
			BRN 	opselect
notprime:	OUT 	R31, 0X02
			BRN 	opselect
;--------------------------------------------------------------------------------
perfect:	MOV 	R2, 0X00	; count variable i
			MOV		R3, 0X00	; sum variable for check
			MOV		DIVIDEND, INPUT	; set dividend as input number
perfloop:	ADD 	R2, 0X01
			MOV		DIVISOR, R2	; set divisor as count variable
			CALL	division
			CMP		REMAINDER, 0X00
			BRNE	perfloop
			ADD		R3, R2
			CMP		R2, INPUT
			BRCS	perfloop
perfcheck:	CMP 	R3, INPUT
			BRNE	notperf
			OUT 	R30, 0X03
			BRN 	opselect
notperf:	OUT 	R31, 0X03
			BRN		opselect
;--------------------------------------------------------------------------------
fibonacci:	MOV		R2, 0X00	; initialize r2 for loop
			MOV		R3, 0X00
			MOV		R4, 0X01	; initialize vars for fibonacci
			CMP		R2, R0		; check if 0
			BREQ	print0
			CMP		R2, MAX_FIB	; check if the value goes beyond 255
			BRCC	print255
			ADD		R2, 0X01	; add iteration	
fibloop:	CMP		R2, R0
			BREQ 	printfib
			ADD		R2, 0X01
			ADD		R3, R4
			MOV		R5, R4		; temp value initialize for movement to current val
			MOV		R4, R3
			MOV		R3, R5
			BRN 	fibloop
print0:		OUT		R3, 0X04
			BRN 	opselect
printfib:	OUT 	R4, 0X04
			BRN		opselect
print255:	OUT		R29, 0X04
;--------------------------------------------------------------------------------
reversed:	MOV 	R2, R0			; move r0 value to r2 for calcs	
			
;--------------------------------------------------------------------------------
divremain:	IN 		R10, 0XFF					; get divisor
			MOV		DIVIDEND, R0				; set input number as dividend
			CMP		DIVIDEND, DIVISOR			; check if divisor greater
			BRCS	pgreater
			CALL 	division
			OUT 	R11, 0X06
			OUT		R12, 0X07
			BRN 	opselect
pgreater:	OUT 	R29, 0X06
			OUT		R29, 0X07
			BRN 	opselect
;--------------------------------------------------------------------------------
division:	MOV		QUOTIENT, 0X00				; quotient value
			MOV 	REMAINDER, DIVIDEND			; make r3 hold input value - becomes remainder
divloop:	CMP 	REMAINDER, DIVISOR			; check input value to divisor
			BRCS	divret
			SUB		REMAINDER, DIVISOR
			ADD		QUOTIENT, 0X01
			BRN 	divloop
divret:		RET
;--------------------------------------------------------------------------------
new_op:

end:		BRN 	end
