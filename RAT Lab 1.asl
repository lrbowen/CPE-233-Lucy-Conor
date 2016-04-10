

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


(0001)                            || ;--------------------------------------------------------------------------------------
(0002)                            || ;- Programmer: Conor Murphy
(0003)                            || ;- Programmer: Lucy Bowen
(0004)                            || ;- Date: 2016.04.05
(0005)                            || ;-
(0006)                            || ;- Program Functionality:  
(0007)                            || ;- Reads in a number from 0x01 : Number user wants information from
(0008)                            || ;- Reads in a number from 0x02 : Option number the user wants to use
(0009)                            || ;- Preforms one of 8 options: 
(0010)                            || ;- 0 : End Program
(0011)                            || ;- 1 : Odd or Even - Output: 0x01 (1 odd, 2 even)
(0012)                            || ;- 2 : Prime Test - Output: 0x02 (1 prime, 2 not prime)
(0013)                            || ;- 3 : Perfect Test - Output: 0x03 (1 perfect, 2 not perfect)
(0014)                            || ;- 4 : Fibonacci Location - Output: 0x04 (number in questioned location)
(0015)                            || ;- 5 : Reverse  - Output: 0x05 (TODO (switch places or reverse all bits?)
(0016)                            || ;- 6 : Divide - Additional Prompt from input 0xFF
(0017)                            || ;-		 	- Output: 0x06 (Quotient)
(0018)                            || ;-			- Output: 0x07 (Remainder)
(0019)                            || ;- 7 : Armstrong Number - Output: 0x08 (1 Armstrong, 2 not Armstrong)
(0020)                            || ;- 
(0021)                            || ;- See ReadMe for more information
(0022)                            || 
(0023)                            || ;--------------------------------------------------------------------------------------
(0024)                            || ;--------------------------------------------------------------------------------------
(0025)                            || ; -Memory Designation Constants
(0026)                            || ;--------------------------------------------------------------------------------------
(0027)                       013  || .EQU 		MAX_FIB 	= 	0X0D			; Decimal - 13
(0028)                            || 
(0029)                       r0   || .DEF		INPUT		= 	R0
(0030)                       r1   || .DEF		OPTION		= 	R1
(0031)                       r30  || .DEF		ONE			= 	R30				; Stationary Location for value of 1
(0032)                       r31  || .DEF		TWO			=  	R31				; Stationary Location for value of 2
(0033)                       r29  || .DEF		MAX			= 	R29				; Stationary Location for value of 255
(0034)                            || 	
(0035)                       r10  || .DEF 		DIVISOR		= 	R10
(0036)                       r11  || .DEF		QUOTIENT	= 	R11
(0037)                       r12  || .DEF		REMAINDER	= 	R12
(0038)                       r13  || .DEF		DIVIDEND	= 	R13
(0039)                            || 
(0040)                            || ;--------------------------------------------------------------------------------------
(0041)                            || ;- Main Program
(0042)                            || ;--------------------------------------------------------------------------------------
(0043)                            || 
(0044)                            || .CSEG
(0045)                       001  || .ORG 0X01
(0046)                            || 
(0047)  CS-0x001  0x32001  0x001  || begin:		IN 		R0,	0X01 			; in port 0x01
(0048)  CS-0x002  0x37E01         || 			MOV 	ONE, 0X01			; output value 1
(0049)  CS-0x003  0x37F02         || 			MOV 	TWO, 0X02			; output value 2
(0050)  CS-0x004  0x37DFF         || 			MOV 	MAX, 0XFF			; output value 255
(0051)                            || ;--------------------------------------------------------------------------------------
(0052)                            || ;- Option Menu
(0053)                            || ;- Registers Used: R1
(0054)                            || ;--------------------------------------------------------------------------------------
(0055)  CS-0x005  0x32102  0x005  || opselect:	IN		R1, 0X02 			; option select
(0056)  CS-0x006  0x30100         || 			CMP 	R1, 0X00			; if 0...go to end
(0057)  CS-0x007  0x0842A         || 			BREQ	end					; 
(0058)  CS-0x008  0x30101         || 			CMP 	R1, 0X01			; if 1...go to determine if even/odd
(0059)  CS-0x009  0x080BA         || 			BREQ 	odd					; 
(0060)  CS-0x00A  0x30102         || 			CMP		R1, 0X02			; if 2...go to determine if prime
(0061)  CS-0x00B  0x080EA         || 			BREQ	prime		
(0062)  CS-0x00C  0x30103         || 			CMP 	R1, 0X03			; if 3...go to perfect
(0063)  CS-0x00D  0x08182         || 			BREQ	perfect
(0064)  CS-0x00E  0x30104         || 			CMP		R1, 0X04			; if 4...go to fibonacci
(0065)  CS-0x00F  0x0820A         || 			BREQ 	fibonacci
(0066)  CS-0x010  0x30105         || 			CMP 	R1, 0X05			; if 5...go to reverse
(0067)  CS-0x011  0x082B2         || 			BREQ 	reversed
(0068)  CS-0x012  0x30106         || 			CMP 	R1, 0X06			; if 6...go to divide
(0069)  CS-0x013  0x082BA         || 			BREQ 	divremain
(0070)  CS-0x014  0x30107         || 			CMP 	R1, 0X07			; if 7...go to our operation
(0071)  CS-0x015  0x08352         || 			BREQ	armstrong
(0072)  CS-0x016  0x08028         || 			BRN 	opselect			; invalid option; pick new
(0073)                            || ;--------------------------------------------------------------------------------------
(0074)                            || ;- Option 1 : Odd / Even
(0075)                            || ;- Registers Used: R0, R30, R31
(0076)                            || ;--------------------------------------------------------------------------------------
(0077)  CS-0x017  0x26001  0x017  || odd:		TEST	INPUT, 0X01			; Zero flag fliped if Zero in LSB
(0078)  CS-0x018  0x080DB         || 			BRNE	printodd			; print odd branch, otherwise print even
(0079)  CS-0x019  0x35F01         || 			OUT		R31, 0x01
(0080)  CS-0x01A  0x08028         || 			BRN 	opselect
(0081)  CS-0x01B  0x35E01  0x01B  || printodd:	OUT		R30, 0x01
(0082)  CS-0x01C  0x08028         || 			BRN 	opselect
(0083)                            || ;--------------------------------------------------------------------------------------
(0084)                            || ;- Option 2 : Prime Test
(0085)                            || ;- Registers Used: R0, R3, R30, R31
(0086)                            || ;- Registers Inherited: R10, R11, R12, R13
(0087)                            || ;--------------------------------------------------------------------------------------
(0088)  CS-0x01D  0x30000  0x01D  || prime:		CMP 	INPUT, 0X00			; 0 check
(0089)  CS-0x01E  0x08172         || 			BREQ	notprime			; if 0, print not prime
(0090)  CS-0x01F  0x30001         || 			CMP 	INPUT, 0X01
(0091)  CS-0x020  0x08172         || 			BREQ	notprime			; if 1, not prime for some reason
(0092)  CS-0x021  0x36A02         || 			MOV 	DIVISOR, 0X02		; set divisor to 2 to check prime
(0093)  CS-0x022  0x04D01         || 			MOV		DIVIDEND, INPUT		; set up to halve R0
(0094)  CS-0x023  0x08311         || 			CALL 	division
(0095)  CS-0x024  0x04359         || 			MOV 	R3, QUOTIENT		; half of R0
(0096)  CS-0x025  0x04A18  0x025  || primeloop:	CMP		DIVISOR, R3			; if i (divisor) <= input/2...
(0097)  CS-0x026  0x0A161         || 			BRCC 	isprime
(0098)  CS-0x027  0x08311         || 			CALL	division
(0099)  CS-0x028  0x30C00         || 			CMP 	REMAINDER, 0X00
(0100)  CS-0x029  0x08172         || 			BREQ	notprime
(0101)  CS-0x02A  0x28A01         || 			ADD		DIVISOR, 0X01
(0102)  CS-0x02B  0x08128         || 			BRN 	primeloop
(0103)  CS-0x02C  0x35E02  0x02C  || isprime:	OUT 	R30, 0X02
(0104)  CS-0x02D  0x08028         || 			BRN 	opselect
(0105)  CS-0x02E  0x35F02  0x02E  || notprime:	OUT 	R31, 0X02
(0106)  CS-0x02F  0x08028         || 			BRN 	opselect
(0107)                            || ;--------------------------------------------------------------------------------------
(0108)                            || ;- Option 3 : Perfect Test
(0109)                            || ;- Registers Used: R0, R2, R3, R30, R31
(0110)                            || ;- Registers Inherited: R10, R11, R12, R13
(0111)                            || ;--------------------------------------------------------------------------------------
(0112)  CS-0x030  0x36200  0x030  || perfect:	MOV 	R2, 0X00			; count variable i
(0113)  CS-0x031  0x36300         || 			MOV		R3, 0X00			; sum variable for check
(0114)  CS-0x032  0x04D01         || 			MOV		DIVIDEND, INPUT		; set dividend as input number
(0115)  CS-0x033  0x28201  0x033  || perfloop:	ADD 	R2, 0X01
(0116)  CS-0x034  0x04A11         || 			MOV		DIVISOR, R2			; set divisor as count variable
(0117)  CS-0x035  0x08311         || 			CALL	division
(0118)  CS-0x036  0x30C00         || 			CMP		REMAINDER, 0X00
(0119)  CS-0x037  0x0819B         || 			BRNE	perfloop
(0120)  CS-0x038  0x02310         || 			ADD		R3, R2
(0121)  CS-0x039  0x04200         || 			CMP		R2, INPUT
(0122)  CS-0x03A  0x0A198         || 			BRCS	perfloop
(0123)  CS-0x03B  0x04300  0x03B  || perfcheck:	CMP 	R3, INPUT
(0124)  CS-0x03C  0x081FB         || 			BRNE	notperf
(0125)  CS-0x03D  0x35E03         || 			OUT 	R30, 0X03
(0126)  CS-0x03E  0x08028         || 			BRN 	opselect
(0127)  CS-0x03F  0x35F03  0x03F  || notperf:	OUT 	R31, 0X03
(0128)  CS-0x040  0x08028         || 			BRN		opselect
(0129)                            || ;--------------------------------------------------------------------------------------
(0130)                            || ;- Option 4 : Fibonacci Location
(0131)                            || ;- Registers Used: R0, R2, R3, R4, R5, R29
(0132)                            || ;--------------------------------------------------------------------------------------
(0133)  CS-0x041  0x36200  0x041  || fibonacci:	MOV		R2, 0X00			; initialize r2 for loop
(0134)  CS-0x042  0x36300         || 			MOV		R3, 0X00
(0135)  CS-0x043  0x36401         || 			MOV		R4, 0X01			; initialize vars for fibonacci
(0136)  CS-0x044  0x04200         || 			CMP		R2, R0				; check if 0
(0137)  CS-0x045  0x0828A         || 			BREQ	print0
(0138)  CS-0x046  0x3020D         || 			CMP		R2, MAX_FIB			; check if the value goes beyond 255
(0139)  CS-0x047  0x0A2A9         || 			BRCC	print255
(0140)  CS-0x048  0x28201         || 			ADD		R2, 0X01			; add iteration	
(0141)  CS-0x049  0x04200  0x049  || fibloop:	CMP		R2, R0
(0142)  CS-0x04A  0x0829A         || 			BREQ 	printfib
(0143)  CS-0x04B  0x28201         || 			ADD		R2, 0X01
(0144)  CS-0x04C  0x02320         || 			ADD		R3, R4
(0145)  CS-0x04D  0x04521         || 			MOV		R5, R4				; temp value initialize for movement to current val
(0146)  CS-0x04E  0x04419         || 			MOV		R4, R3
(0147)  CS-0x04F  0x04329         || 			MOV		R3, R5
(0148)  CS-0x050  0x08248         || 			BRN 	fibloop
(0149)  CS-0x051  0x34304  0x051  || print0:		OUT		R3, 0X04
(0150)  CS-0x052  0x08028         || 			BRN 	opselect
(0151)  CS-0x053  0x34404  0x053  || printfib:	OUT 	R4, 0X04
(0152)  CS-0x054  0x08028         || 			BRN		opselect
(0153)  CS-0x055  0x35D04  0x055  || print255:	OUT		R29, 0X04
(0154)                            || ;--------------------------------------------------------------------------------------
(0155)                            || ;- Option 5 : Reverse
(0156)                            || ;--------------------------------------------------------------------------------------
(0157)  CS-0x056  0x04201  0x056  || reversed:	MOV 	R2, R0				; move r0 value to r2 for calcs	
(0158)                            || ;--------------------------------------------------------------------------------------
(0159)                            || ;- Option 6 : Divide
(0160)                            || ;- Registers Used: R10, R11, R12, R13, R29
(0161)                            || ;--------------------------------------------------------------------------------------	
(0162)  CS-0x057  0x32AFF  0x057  || divremain:	IN 		R10, 0XFF					; get divisor
(0163)  CS-0x058  0x04D01         || 			MOV		DIVIDEND, R0				; set input number as dividend
(0164)  CS-0x059  0x04D50         || 			CMP		DIVIDEND, DIVISOR			; check if divisor greater
(0165)  CS-0x05A  0x0A2F8         || 			BRCS	pgreater
(0166)  CS-0x05B  0x08311         || 			CALL 	division
(0167)  CS-0x05C  0x34B06         || 			OUT 	R11, 0X06
(0168)  CS-0x05D  0x34C07         || 			OUT		R12, 0X07
(0169)  CS-0x05E  0x08028         || 			BRN 	opselect
(0170)  CS-0x05F  0x35D06  0x05F  || pgreater:	OUT 	R29, 0X06
(0171)  CS-0x060  0x35D07         || 			OUT		R29, 0X07
(0172)  CS-0x061  0x08028         || 			BRN 	opselect
(0173)                            || ;--------------------------------------------------------------------------------------
(0174)                            || ;- Option 6a : Division Logic
(0175)                            || ;- Registers Used: R10, R11, R12, R13, R29
(0176)                            || ;--------------------------------------------------------------------------------------
(0177)  CS-0x062  0x36B00  0x062  || division:	MOV		QUOTIENT, 0X00				; quotient value
(0178)  CS-0x063  0x04C69         || 			MOV 	REMAINDER, DIVIDEND			; make r3 hold input value - becomes remainder
(0179)  CS-0x064  0x04C50  0x064  || divloop:	CMP 	REMAINDER, DIVISOR			; check input value to divisor
(0180)  CS-0x065  0x0A348         || 			BRCS	divret
(0181)  CS-0x066  0x02C52         || 			SUB		REMAINDER, DIVISOR
(0182)  CS-0x067  0x28B01         || 			ADD		QUOTIENT, 0X01
(0183)  CS-0x068  0x08320         || 			BRN 	divloop
(0184)  CS-0x069  0x18002  0x069  || divret:		RET
(0185)                            || ;--------------------------------------------------------------------------------------
(0186)                            || ;- Option 7 : Armstrong Number
(0187)                            || ;- Registers Used: R0, R2, R7, R30, R31
(0188)                            || ;- Registers Inherited: R10, R11, R12, R13
(0189)                            || ;--------------------------------------------------------------------------------------
(0190)  CS-0x06A  0x04701  0x06A  || armstrong:  MOV		R7, R0						; Save Copy of Number
(0191)  CS-0x06B  0x36200         || 			MOV		R2, 0x00					; Clear R2 (Sum)
(0192)  CS-0x06C  0x36A0A         || 			MOV 	DIVISOR, 0X0A				; Set up Divisor for Armstrong Test
(0193)  CS-0x06D  0x04D01         || 			MOV		DIVIDEND, R0
(0194)  CS-0x06E  0x08311  0x06E  || armloop:	CALL 	division
(0195)  CS-0x06F  0x04D59         || 			MOV		DIVIDEND, QUOTIENT
(0196)  CS-0x070  0x083D1         || 			CALL	armsum
(0197)  CS-0x071  0x02230         || 			ADD		R2, R6
(0198)  CS-0x072  0x30D00         || 			CMP		DIVIDEND, 0x00
(0199)  CS-0x073  0x08373         || 			BRNE	armloop
(0200)  CS-0x074  0x04200  0x074  || armcheck:	CMP		R2, R0
(0201)  CS-0x075  0x083C3         || 			BRNE	noarm
(0202)  CS-0x076  0x35E08  0x076  || yesarm:		OUT 	R30, 0X08
(0203)  CS-0x077  0x08028         || 			BRN 	opselect
(0204)  CS-0x078  0x35F08  0x078  || noarm:		OUT 	R31, 0X08
(0205)  CS-0x079  0x08028         || 			BRN		opselect
(0206)                            || ;--------------------------------------------------------------------------------------
(0207)                            || ;- Option 7a : Armstrong Power Logic
(0208)                            || ;--------------------------------------------------------------------------------------
(0209)  CS-0x07A  0x04361  0x07A  || armsum:		MOV		R3, REMAINDER
(0210)  CS-0x07B  0x04461         || 			MOV		R4, REMAINDER				; Power Counter
(0211)  CS-0x07C  0x36500         || 			MOV		R5, 0x00
(0212)  CS-0x07D  0x36600         || 			MOV		R6, 0x00
(0213)                            || 				
(0214)  CS-0x07E  0x02560  0x07E  || sumloop1:	ADD		R5, REMAINDER				
(0215)  CS-0x07F  0x2C301         || 			SUB		R3, 0x01					; Addition Counting
(0216)  CS-0x080  0x083F3         || 			BRNE	sumloop1
(0217)  CS-0x081  0x02628  0x081  || sumloop2:	ADD		R6, R5
(0218)  CS-0x082  0x2C401         || 			SUB		R4, 0x01					; Power Counting
(0219)  CS-0x083  0x0840B         || 			BRNE	sumloop2
(0220)  CS-0x084  0x18002  0x084  || armend:		RET
(0221)                            || 
(0222)                            || 
(0223)  CS-0x085  0x08428  0x085  || end:		BRN 	end





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
ARMCHECK       0x074   (0200)  ||  
ARMEND         0x084   (0220)  ||  
ARMLOOP        0x06E   (0194)  ||  0199 
ARMSTRONG      0x06A   (0190)  ||  0071 
ARMSUM         0x07A   (0209)  ||  0196 
BEGIN          0x001   (0047)  ||  
DIVISION       0x062   (0177)  ||  0094 0098 0117 0166 0194 
DIVLOOP        0x064   (0179)  ||  0183 
DIVREMAIN      0x057   (0162)  ||  0069 
DIVRET         0x069   (0184)  ||  0180 
END            0x085   (0223)  ||  0057 0223 
FIBLOOP        0x049   (0141)  ||  0148 
FIBONACCI      0x041   (0133)  ||  0065 
ISPRIME        0x02C   (0103)  ||  0097 
NOARM          0x078   (0204)  ||  0201 
NOTPERF        0x03F   (0127)  ||  0124 
NOTPRIME       0x02E   (0105)  ||  0089 0091 0100 
ODD            0x017   (0077)  ||  0059 
OPSELECT       0x005   (0055)  ||  0072 0080 0082 0104 0106 0126 0128 0150 0152 0169 
                               ||  0172 0203 0205 
PERFCHECK      0x03B   (0123)  ||  
PERFECT        0x030   (0112)  ||  0063 
PERFLOOP       0x033   (0115)  ||  0119 0122 
PGREATER       0x05F   (0170)  ||  0165 
PRIME          0x01D   (0088)  ||  0061 
PRIMELOOP      0x025   (0096)  ||  0102 
PRINT0         0x051   (0149)  ||  0137 
PRINT255       0x055   (0153)  ||  0139 
PRINTFIB       0x053   (0151)  ||  0142 
PRINTODD       0x01B   (0081)  ||  0078 
REVERSED       0x056   (0157)  ||  0067 
SUMLOOP1       0x07E   (0214)  ||  0216 
SUMLOOP2       0x081   (0217)  ||  0219 
YESARM         0x076   (0202)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
MAX_FIB        0x00D   (0027)  ||  0138 


-- Directives: .DEF
------------------------------------------------------------ 
DIVIDEND         r13   (0038)  ||  0093 0114 0163 0164 0178 0193 0195 0198 
DIVISOR          r10   (0035)  ||  0092 0096 0101 0116 0164 0179 0181 0192 
INPUT            r0    (0029)  ||  0077 0088 0090 0093 0114 0121 0123 
MAX              r29   (0033)  ||  0050 
ONE              r30   (0031)  ||  0048 
OPTION           r1    (0030)  ||  
QUOTIENT         r11   (0036)  ||  0095 0177 0182 0195 
REMAINDER        r12   (0037)  ||  0099 0118 0178 0179 0181 0209 0210 0214 
TWO              r31   (0032)  ||  0049 


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
