;--------------------------------------------------------------------------------------
;- Programmer: Conor Murphy
;- Programmer: Lucy Bowen
;- Date: 2016.04.05
;-
;- Program Functionality:  
;- Reads in a number from 0x01 : Number user wants information from
;- Reads in a number from 0x02 : Option number the user wants to use
;- Preforms one of 8 options: 
;- 0 : End Program
;- 1 : Odd or Even          - Output: 0x01 (1 odd, 2 even)
;- 2 : Prime Test           - Output: 0x02 (1 prime, 2 not prime)
;- 3 : Perfect Test         - Output: 0x03 (1 perfect, 2 not perfect)
;- 4 : Fibonacci Location   - Output: 0x04 (number in questioned location)
;- 5 : Reverse              - Output: 0x05
;- 6 : Divide - Additional Prompt from input 0xFF
;-		 	                - Output: 0x06 (Quotient)
;-			                - Output: 0x07 (Remainder)
;- 7 : Armstrong Number     - Output: 0x08 (1 Armstrong, 2 not Armstrong)
;--------------------------------------------------------------------------------------
; -Memory Designation Constants
;--------------------------------------------------------------------------------------
.EQU 		MAX_FIB 	= 	0X0D	; Decimal - 13

.DEF		INPUT		= 	R0
.DEF		OPTION		= 	R1
.DEF		ONE			= 	R30		; Stationary Location for value of 1
.DEF		TWO			=  	R31		; Stationary Location for value of 2
.DEF		MAX			= 	R29		; Stationary Location for value of 255
	
.DEF 		DIVISOR		= 	R10
.DEF		QUOTIENT	= 	R11
.DEF		REMAINDER	= 	R12
.DEF		DIVIDEND	= 	R13

;--------------------------------------------------------------------------------------
;- Main Program
;--------------------------------------------------------------------------------------

.CSEG
.ORG 0X01

begin:	
		IN 		R0,  0X01 			; in port 0x01
		MOV 	ONE, 0X01			; output value 1
		MOV 	TWO, 0X02			; output value 2
		MOV 	MAX, 0XFF			; output value 255
;--------------------------------------------------------------------------------------
;- Option Menu
;- Registers Used: R1
;--------------------------------------------------------------------------------------
opselect:	
		IN		R1, 0X02 			; option select
		CMP 	R1, 0X00			; if 0...go to end
		BREQ	end					 
		CMP 	R1, 0X01			; if 1...go to determine if even/odd
		BREQ 	odd					 
		CMP		R1, 0X02			; if 2...go to determine if prime
		BREQ	prime		
		CMP 	R1, 0X03			; if 3...go to perfect
		BREQ	perfect
		CMP		R1, 0X04			; if 4...go to fibonacci
		BREQ 	fibonacci
		CMP 	R1, 0X05			; if 5...go to reverse
		BREQ 	reversed
		CMP 	R1, 0X06			; if 6...go to divide
		BREQ 	divremain
		CMP 	R1, 0X07			; if 7...go to our operation
		BREQ	armstrong
		BRN 	opselect			; invalid option; pick new
;--------------------------------------------------------------------------------------
;- Option 1 : Odd / Even
;- Registers Used: R0, R30, R31
;--------------------------------------------------------------------------------------
odd:	TEST	INPUT, 0X01			; Zero flag fliped if Zero in LSB
		BRNE	printodd			; print odd branch, otherwise print even
		OUT		R31, 0x01			; print 1 if odd
		BRN 	opselect
printodd:	
		OUT		R30, 0x01			; print 2 if even
		BRN 	opselect
;--------------------------------------------------------------------------------------
;- Option 2 : Prime Test
;- Registers Used: R0, R3, R30, R31
;- Registers Inherited: R10, R11, R12, R13
;--------------------------------------------------------------------------------------
prime:	CMP 	INPUT, 0X00			; 0 check
		BREQ	notprime			; if 0, print not prime
		CMP 	INPUT, 0X01
		BREQ	notprime			; if 1, not prime for some reason
		MOV 	DIVISOR, 0X02		; set divisor to 2 to check prime
		MOV		DIVIDEND, INPUT		; set up to halve R0
		CALL 	division
		MOV 	R3, QUOTIENT		; half of R0
primeloop:	
		CMP		DIVISOR, R3			; if i (divisor) <= input/2...
		BRCC 	isprime
		CALL	division
		CMP 	REMAINDER, 0X00
		BREQ	notprime
		ADD		DIVISOR, 0X01
		BRN 	primeloop
isprime:	
		OUT 	R30, 0X02			; print 1 if prime
		BRN 	opselect
notprime:	
		OUT 	R31, 0X02			; print 2 if not prime
		BRN 	opselect
;--------------------------------------------------------------------------------------
;- Option 3 : Perfect Test
;- Registers Used: R0, R2, R3, R30, R31
;- Registers Inherited: R10, R11, R12, R13
;--------------------------------------------------------------------------------------
perfect:	
		MOV 	R2, 0X00			; count variable
		MOV		R3, 0X00			; sum variable for check
		MOV		DIVIDEND, INPUT		; set dividend as input number
perfloop:		
		ADD 	R2, 0X01
		CMP		R2, INPUT
		BREQ	perfcheck
		MOV		DIVISOR, R2			; set divisor as count variable
		CALL	division
		CMP		REMAINDER, 0X00
		BRNE	perfloop
		ADD		R3, R2				; bug- happens an extra time
		CMP		R2, INPUT
		BRCS	perfloop
perfcheck:	
		CMP 	R3, INPUT			
		BRNE	notperf
		OUT 	R30, 0X03			; print 1 if perfect
		BRN 	opselect
notperf:	
		OUT 	R31, 0X03			; print 2 if not perfect
		BRN		opselect
;--------------------------------------------------------------------------------------
;- Option 4 : Fibonacci Location
;- Registers Used: R0, R2, R3, R4, R5, R29
;--------------------------------------------------------------------------------------
fibonacci:	
		MOV		R2, 0X00			; initialize r2 for loop
		MOV		R3, 0X00
		MOV		R4, 0X01			; initialize vars for fibonacci
		CMP		R2, R0				; check if 0
		BREQ	print0
		CMP		R2, MAX_FIB			; check if the value goes beyond 255
		BRCC	print255
		ADD		R2, 0X01			; add iteration	
fibloop:	
		CMP		R2, R0
		BREQ 	printfib
		ADD		R2, 0X01
		ADD		R3, R4
		MOV		R5, R4				; temp value initialize for movement to current val
		MOV		R4, R3
		MOV		R3, R5
		BRN 	fibloop
print0:		
		OUT		R3, 0X04
		BRN 	opselect
printfib:	
		OUT 	R4, 0X04
		BRN		opselect
print255:	
		OUT		R29, 0X04
;--------------------------------------------------------------------------------------
;- Option 5 : Reverse
;- Registers Used: R2, R3
;--------------------------------------------------------------------------------------
reversed:	
		MOV 	R2, R0				; move r0 value to r2 for calcs
		MOV		R3, 0x00			; empty register
		MOV		R4, 0x01			; test register
		MOV		R5, 0x08
		ROL		R2					; First Rotate Left
revloop:
		AND		R4, R2				; Select LSB of R2 into R4
		OR		R3, R4
		ROR		R3
		ROL		R2
		MOV		R4, 0x01
		SUB		R5, 0x01
		BRNE	revloop
revprint:
		OUT		R3, 0x05
		BRN		opselect
;--------------------------------------------------------------------------------------
;- Option 6 : Divide
;- Registers Used: R10, R11, R12, R13, R29
;--------------------------------------------------------------------------------------	
divremain:	
		IN 		R10, 0XFF			; get divisor
		MOV		DIVIDEND, R0		; set input number as dividend
		CMP		DIVIDEND, DIVISOR	; check if divisor greater
		BRCS	pgreater
		CALL 	division
		OUT 	R11, 0X06
		OUT		R12, 0X07
		BRN 	opselect
pgreater:	
		OUT 	R29, 0X06
		OUT		R29, 0X07
		BRN 	opselect
;--------------------------------------------------------------------------------------
;- Option 6a : Division Logic
;- Registers Used: R10, R11, R12, R13, R29
;--------------------------------------------------------------------------------------
division:	
		MOV		QUOTIENT, 0X00		; quotient value
		MOV 	REMAINDER, DIVIDEND	; make r3 hold input value - becomes remainder
divloop:	
		CMP 	REMAINDER, DIVISOR	; check input value to divisor
		BRCS 	divret
		SUB		REMAINDER, DIVISOR
		ADD		QUOTIENT, 0X01
		BRN 	divloop
divret:	RET
;--------------------------------------------------------------------------------------
;- Option 7 : Armstrong Number
;- Registers Used: R0, R2, R7, R30, R31
;- Registers Inherited: R3, R4, R5, R6, R10, R11, R12, R13
;--------------------------------------------------------------------------------------
armstrong:	
		MOV		R7, R0				; Save Copy of Number
		MOV		R2, 0x00			; Clear R2 (Sum)
		MOV 	DIVISOR, 0X0A		; Set up Divisor for Armstrong Test
		MOV		DIVIDEND, R0
armloop:
		CALL 	division
		MOV		DIVIDEND, QUOTIENT
		CALL 	armsum
		ADD		R2, R6
		CMP		DIVIDEND, 0x00
		BRNE 	armloop
armcheck:	
		CMP		R2, R0
		BRNE 	noarm
yesarm:		
		OUT 	R30, 0X08			; print 1 if armstrong
		BRN 	opselect
noarm:	OUT 	R31, 0X08			; print 2 if not armstrong
		BRN		opselect
;--------------------------------------------------------------------------------------
;- Option 7a : Armstrong Power Logic
;- Registers Used: R3, R4, R5, R6
;- Registers Inherited: R12
;--------------------------------------------------------------------------------------
armsum:	MOV		R3, REMAINDER
		MOV		R4, REMAINDER		; Power Counter
		MOV		R5, 0x00
		MOV		R6, 0x00
				
sumloop1:
		ADD		R5, REMAINDER				
		SUB		R3, 0x01			; Addition Counting
		BRNE 	sumloop1
sumloop2:	
		ADD		R6, R5
		SUB		R4, 0x01			; Power Counting
		BRNE 	sumloop2
armend:	RET


end:	BRN 	end
