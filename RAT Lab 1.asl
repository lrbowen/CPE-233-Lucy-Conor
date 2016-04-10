

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;-------------------------------------------------------------------------------
(0002)                            || ;
(0003)                            || ; Authors: Conor Murphy, Lucy Bowen
(0004)                            || ;
(0005)                            || ;-------------------------------------------------------------------------------
(0006)                       013  || .EQU 		MAX_FIB 	= 	0X0D
(0007)                            || 
(0008)                       r0   || .DEF		INPUT		= 	R0
(0009)                       r1   || .DEF		OPTION		= 	R1
(0010)                       r30  || .DEF		ONE			= 	R30
(0011)                       r31  || .DEF		TWO			=  	R31
(0012)                       r29  || .DEF		MAX			= 	R29
(0013)                            || 	
(0014)                       r10  || .DEF 		DIVISOR		= 	R10
(0015)                       r11  || .DEF		QUOTIENT	= 	R11
(0016)                       r12  || .DEF		REMAINDER	= 	R12
(0017)                       r13  || .DEF		DIVIDEND	= 	R13
(0018)                            || 
(0019)                            || .CSEG
(0020)                       001  || .ORG 0X01
(0021)                            || 
(0022)  CS-0x001  0x32001  0x001  || begin:		IN 		R0,	0X01 	; in port 0x01
(0023)  CS-0x002  0x37E01         || 			MOV 	ONE, 0X01	; output value 1
(0024)  CS-0x003  0x37F02         || 			MOV 	TWO, 0X02	; output value 2
(0025)  CS-0x004  0x37DFF         || 			MOV 	MAX, 0XFF	; output value 255
(0026)                            || ;--------------------------------------------------------------------------------
(0027)  CS-0x005  0x32102  0x005  || opselect:	IN		R1, 0X02 	; option select
(0028)  CS-0x006  0x30100         || 			CMP 	R1, 0X00	; if 0...go to end
(0029)  CS-0x007  0x08352         || 			BREQ	end			; 
(0030)  CS-0x008  0x30101         || 			CMP 	R1, 0X01	; if 1...go to determine if even/odd
(0031)  CS-0x009  0x080BA         || 			BREQ 	odd			; 
(0032)  CS-0x00A  0x30102         || 			CMP		R1, 0X02	; if 2...go to determine if prime
(0033)  CS-0x00B  0x080EA         || 			BREQ	prime		
(0034)  CS-0x00C  0x30103         || 			CMP 	R1, 0X03	; if 3...go to perfect
(0035)  CS-0x00D  0x08182         || 			BREQ	perfect
(0036)  CS-0x00E  0x30104         || 			CMP		R1, 0X04	; if 4...go to fibonacci
(0037)  CS-0x00F  0x0820A         || 			BREQ 	fibonacci
(0038)  CS-0x010  0x30105         || 			CMP 	R1, 0X05	; if 5...go to reverse
(0039)  CS-0x011  0x082B2         || 			BREQ 	reversed
(0040)  CS-0x012  0x30106         || 			CMP 	R1, 0X06	; if 6...go to divide
(0041)  CS-0x013  0x082BA         || 			BREQ 	divremain
(0042)  CS-0x014  0x30107         || 			CMP 	R1, 0X07	; if 7...go to our operation
(0043)  CS-0x015  0x08352         || 			BREQ	new_op
(0044)  CS-0x016  0x08028         || 			BRN 	opselect		; invalid option; pick new
(0045)                            || ;--------------------------------------------------------------------------------
(0046)  CS-0x017  0x26001  0x017  || odd:		TEST	R0, 0X01	; OPTION 1
(0047)  CS-0x018  0x080DB         || 			BRNE	printodd	; print odd branch, otherwise print even
(0048)  CS-0x019  0x35F01         || 			OUT		R31, 0x01
(0049)  CS-0x01A  0x08028         || 			BRN 	opselect
(0050)  CS-0x01B  0x35E02  0x01B  || printodd:	OUT		R30, 0x02
(0051)  CS-0x01C  0x08028         || 			BRN 	opselect
(0052)                            || ;--------------------------------------------------------------------------------
(0053)  CS-0x01D  0x30000  0x01D  || prime:		CMP 	R0, 0X00				; 0 check
(0054)  CS-0x01E  0x08172         || 			BREQ	notprime				; if 0, print not prime
(0055)  CS-0x01F  0x30001         || 			CMP 	R0, 0X01
(0056)  CS-0x020  0x08172         || 			BREQ	notprime				; if 1, not prime for some reason
(0057)  CS-0x021  0x36A02         || 			MOV 	DIVISOR, 0X02				; set divisor to 2 to check prime
(0058)  CS-0x022  0x04D01         || 			MOV		DIVIDEND, R0				; set up to halve R0
(0059)  CS-0x023  0x08311         || 			CALL 	division
(0060)  CS-0x024  0x04359         || 			MOV 	R3, QUOTIENT					; half of R0
(0061)  CS-0x025  0x04A18  0x025  || primeloop:	CMP		DIVISOR, R3					; if i (divisor) <= input/2...
(0062)  CS-0x026  0x0A161         || 			BRCC 	isprime
(0063)  CS-0x027  0x08311         || 			CALL	division
(0064)  CS-0x028  0x30C00         || 			CMP 	REMAINDER, 0X00
(0065)  CS-0x029  0x08172         || 			BREQ	notprime
(0066)  CS-0x02A  0x28A01         || 			ADD		DIVISOR, 0X01
(0067)  CS-0x02B  0x08128         || 			BRN 	primeloop
(0068)  CS-0x02C  0x35E02  0x02C  || isprime:	OUT 	R30, 0X02
(0069)  CS-0x02D  0x08028         || 			BRN 	opselect
(0070)  CS-0x02E  0x35F02  0x02E  || notprime:	OUT 	R31, 0X02
(0071)  CS-0x02F  0x08028         || 			BRN 	opselect
(0072)                            || ;--------------------------------------------------------------------------------
(0073)  CS-0x030  0x36200  0x030  || perfect:	MOV 	R2, 0X00	; count variable i
(0074)  CS-0x031  0x36300         || 			MOV		R3, 0X00	; sum variable for check
(0075)  CS-0x032  0x04D01         || 			MOV		DIVIDEND, INPUT	; set dividend as input number
(0076)  CS-0x033  0x28201  0x033  || perfloop:	ADD 	R2, 0X01
(0077)  CS-0x034  0x04A11         || 			MOV		DIVISOR, R2	; set divisor as count variable
(0078)  CS-0x035  0x08311         || 			CALL	division
(0079)  CS-0x036  0x30C00         || 			CMP		REMAINDER, 0X00
(0080)  CS-0x037  0x0819B         || 			BRNE	perfloop
(0081)  CS-0x038  0x02310         || 			ADD		R3, R2
(0082)  CS-0x039  0x04200         || 			CMP		R2, INPUT
(0083)  CS-0x03A  0x0A198         || 			BRCS	perfloop
(0084)  CS-0x03B  0x04300  0x03B  || perfcheck:	CMP 	R3, INPUT
(0085)  CS-0x03C  0x081FB         || 			BRNE	notperf
(0086)  CS-0x03D  0x35E03         || 			OUT 	R30, 0X03
(0087)  CS-0x03E  0x08028         || 			BRN 	opselect
(0088)  CS-0x03F  0x35F03  0x03F  || notperf:	OUT 	R31, 0X03
(0089)  CS-0x040  0x08028         || 			BRN		opselect
(0090)                            || ;--------------------------------------------------------------------------------
(0091)  CS-0x041  0x36200  0x041  || fibonacci:	MOV		R2, 0X00	; initialize r2 for loop
(0092)  CS-0x042  0x36300         || 			MOV		R3, 0X00
(0093)  CS-0x043  0x36401         || 			MOV		R4, 0X01	; initialize vars for fibonacci
(0094)  CS-0x044  0x04200         || 			CMP		R2, R0		; check if 0
(0095)  CS-0x045  0x0828A         || 			BREQ	print0
(0096)  CS-0x046  0x3020D         || 			CMP		R2, MAX_FIB	; check if the value goes beyond 255
(0097)  CS-0x047  0x0A2A9         || 			BRCC	print255
(0098)  CS-0x048  0x28201         || 			ADD		R2, 0X01	; add iteration	
(0099)  CS-0x049  0x04200  0x049  || fibloop:	CMP		R2, R0
(0100)  CS-0x04A  0x0829A         || 			BREQ 	printfib
(0101)  CS-0x04B  0x28201         || 			ADD		R2, 0X01
(0102)  CS-0x04C  0x02320         || 			ADD		R3, R4
(0103)  CS-0x04D  0x04521         || 			MOV		R5, R4		; temp value initialize for movement to current val
(0104)  CS-0x04E  0x04419         || 			MOV		R4, R3
(0105)  CS-0x04F  0x04329         || 			MOV		R3, R5
(0106)  CS-0x050  0x08248         || 			BRN 	fibloop
(0107)  CS-0x051  0x34304  0x051  || print0:		OUT		R3, 0X04
(0108)  CS-0x052  0x08028         || 			BRN 	opselect
(0109)  CS-0x053  0x34404  0x053  || printfib:	OUT 	R4, 0X04
(0110)  CS-0x054  0x08028         || 			BRN		opselect
(0111)  CS-0x055  0x35D04  0x055  || print255:	OUT		R29, 0X04
(0112)                            || ;--------------------------------------------------------------------------------
(0113)  CS-0x056  0x04201  0x056  || reversed:	MOV 	R2, R0			; move r0 value to r2 for calcs	
(0114)                            || 			
(0115)                            || ;--------------------------------------------------------------------------------
(0116)  CS-0x057  0x32AFF  0x057  || divremain:	IN 		R10, 0XFF					; get divisor
(0117)  CS-0x058  0x04D01         || 			MOV		DIVIDEND, R0				; set input number as dividend
(0118)  CS-0x059  0x04D50         || 			CMP		DIVIDEND, DIVISOR			; check if divisor greater
(0119)  CS-0x05A  0x0A2F8         || 			BRCS	pgreater
(0120)  CS-0x05B  0x08311         || 			CALL 	division
(0121)  CS-0x05C  0x34B06         || 			OUT 	R11, 0X06
(0122)  CS-0x05D  0x34C07         || 			OUT		R12, 0X07
(0123)  CS-0x05E  0x08028         || 			BRN 	opselect
(0124)  CS-0x05F  0x35D06  0x05F  || pgreater:	OUT 	R29, 0X06
(0125)  CS-0x060  0x35D07         || 			OUT		R29, 0X07
(0126)  CS-0x061  0x08028         || 			BRN 	opselect
(0127)                            || ;--------------------------------------------------------------------------------
(0128)  CS-0x062  0x36B00  0x062  || division:	MOV		QUOTIENT, 0X00				; quotient value
(0129)  CS-0x063  0x04C69         || 			MOV 	REMAINDER, DIVIDEND			; make r3 hold input value - becomes remainder
(0130)  CS-0x064  0x04C50  0x064  || divloop:	CMP 	REMAINDER, DIVISOR			; check input value to divisor
(0131)  CS-0x065  0x0A348         || 			BRCS	divret
(0132)  CS-0x066  0x02C52         || 			SUB		REMAINDER, DIVISOR
(0133)  CS-0x067  0x28B01         || 			ADD		QUOTIENT, 0X01
(0134)  CS-0x068  0x08320         || 			BRN 	divloop
(0135)  CS-0x069  0x18002  0x069  || divret:		RET
(0136)                            || ;--------------------------------------------------------------------------------
(0137)                     0x06A  || new_op:
(0138)                            || 
(0139)  CS-0x06A  0x08350  0x06A  || end:		BRN 	end





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
BEGIN          0x001   (0022)  ||  
DIVISION       0x062   (0128)  ||  0059 0063 0078 0120 
DIVLOOP        0x064   (0130)  ||  0134 
DIVREMAIN      0x057   (0116)  ||  0041 
DIVRET         0x069   (0135)  ||  0131 
END            0x06A   (0139)  ||  0029 0139 
FIBLOOP        0x049   (0099)  ||  0106 
FIBONACCI      0x041   (0091)  ||  0037 
ISPRIME        0x02C   (0068)  ||  0062 
NEW_OP         0x06A   (0137)  ||  0043 
NOTPERF        0x03F   (0088)  ||  0085 
NOTPRIME       0x02E   (0070)  ||  0054 0056 0065 
ODD            0x017   (0046)  ||  0031 
OPSELECT       0x005   (0027)  ||  0044 0049 0051 0069 0071 0087 0089 0108 0110 0123 
                               ||  0126 
PERFCHECK      0x03B   (0084)  ||  
PERFECT        0x030   (0073)  ||  0035 
PERFLOOP       0x033   (0076)  ||  0080 0083 
PGREATER       0x05F   (0124)  ||  0119 
PRIME          0x01D   (0053)  ||  0033 
PRIMELOOP      0x025   (0061)  ||  0067 
PRINT0         0x051   (0107)  ||  0095 
PRINT255       0x055   (0111)  ||  0097 
PRINTFIB       0x053   (0109)  ||  0100 
PRINTODD       0x01B   (0050)  ||  0047 
REVERSED       0x056   (0113)  ||  0039 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
MAX_FIB        0x00D   (0006)  ||  0096 


-- Directives: .DEF
------------------------------------------------------------ 
DIVIDEND         r13   (0017)  ||  0058 0075 0117 0118 0129 
DIVISOR          r10   (0014)  ||  0057 0061 0066 0077 0118 0130 0132 
INPUT            r0    (0008)  ||  0075 0082 0084 
MAX              r29   (0012)  ||  0025 
ONE              r30   (0010)  ||  0023 
OPTION           r1    (0009)  ||  
QUOTIENT         r11   (0015)  ||  0060 0128 0133 
REMAINDER        r12   (0016)  ||  0064 0079 0129 0130 0132 
TWO              r31   (0011)  ||  0024 


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
