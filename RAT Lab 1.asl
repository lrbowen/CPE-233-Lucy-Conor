

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
(0011)                            || ;- 1 : Odd or Even          - Output: 0x01 (1 odd, 2 even)
(0012)                            || ;- 2 : Prime Test           - Output: 0x02 (1 prime, 2 not prime)
(0013)                            || ;- 3 : Perfect Test         - Output: 0x03 (1 perfect, 2 not perfect)
(0014)                            || ;- 4 : Fibonacci Location   - Output: 0x04 (number in questioned location)
(0015)                            || ;- 5 : Reverse              - Output: 0x05 (TODO (reverse bits)
(0016)                            || ;- 6 : Divide - Additional Prompt from input 0xFF
(0017)                            || ;-		 	                - Output: 0x06 (Quotient)
(0018)                            || ;-			                - Output: 0x07 (Remainder)
(0019)                            || ;- 7 : Armstrong Number     - Output: 0x08 (1 Armstrong, 2 not Armstrong)
(0020)                            || ;--------------------------------------------------------------------------------------
(0021)                            || ; -Memory Designation Constants
(0022)                            || ;--------------------------------------------------------------------------------------
(0023)                       013  || .EQU 		MAX_FIB 	= 	0X0D	; Decimal - 13
(0024)                            || 
(0025)                       r0   || .DEF		INPUT		= 	R0
(0026)                       r1   || .DEF		OPTION		= 	R1
(0027)                       r30  || .DEF		ONE			= 	R30		; Stationary Location for value of 1
(0028)                       r31  || .DEF		TWO			=  	R31		; Stationary Location for value of 2
(0029)                       r29  || .DEF		MAX			= 	R29		; Stationary Location for value of 255
(0030)                            || 	
(0031)                       r10  || .DEF 		DIVISOR		= 	R10
(0032)                       r11  || .DEF		QUOTIENT	= 	R11
(0033)                       r12  || .DEF		REMAINDER	= 	R12
(0034)                       r13  || .DEF		DIVIDEND	= 	R13
(0035)                            || 
(0036)                            || ;--------------------------------------------------------------------------------------
(0037)                            || ;- Main Program
(0038)                            || ;--------------------------------------------------------------------------------------
(0039)                            || 
(0040)                            || .CSEG
(0041)                       001  || .ORG 0X01
(0042)                            || 
(0043)                     0x001  || begin:	
(0044)  CS-0x001  0x32001         || 		IN 		R0,  0X01 			; in port 0x01
(0045)  CS-0x002  0x37E01         || 		MOV 	ONE, 0X01			; output value 1
(0046)  CS-0x003  0x37F02         || 		MOV 	TWO, 0X02			; output value 2
(0047)  CS-0x004  0x37DFF         || 		MOV 	MAX, 0XFF			; output value 255
(0048)                            || ;--------------------------------------------------------------------------------------
(0049)                            || ;- Option Menu
(0050)                            || ;- Registers Used: R1
(0051)                            || ;--------------------------------------------------------------------------------------
(0052)                     0x005  || opselect:	
(0053)  CS-0x005  0x32102         || 		IN		R1, 0X02 			; option select
(0054)  CS-0x006  0x30100         || 		CMP 	R1, 0X00			; if 0...go to end
(0055)  CS-0x007  0x084A2         || 		BREQ	end					 
(0056)  CS-0x008  0x30101         || 		CMP 	R1, 0X01			; if 1...go to determine if even/odd
(0057)  CS-0x009  0x080BA         || 		BREQ 	odd					 
(0058)  CS-0x00A  0x30102         || 		CMP		R1, 0X02			; if 2...go to determine if prime
(0059)  CS-0x00B  0x080EA         || 		BREQ	prime		
(0060)  CS-0x00C  0x30103         || 		CMP 	R1, 0X03			; if 3...go to perfect
(0061)  CS-0x00D  0x08182         || 		BREQ	perfect
(0062)  CS-0x00E  0x30104         || 		CMP		R1, 0X04			; if 4...go to fibonacci
(0063)  CS-0x00F  0x0821A         || 		BREQ 	fibonacci
(0064)  CS-0x010  0x30105         || 		CMP 	R1, 0X05			; if 5...go to reverse
(0065)  CS-0x011  0x082C2         || 		BREQ 	reversed
(0066)  CS-0x012  0x30106         || 		CMP 	R1, 0X06			; if 6...go to divide
(0067)  CS-0x013  0x08332         || 		BREQ 	divremain
(0068)  CS-0x014  0x30107         || 		CMP 	R1, 0X07			; if 7...go to our operation
(0069)  CS-0x015  0x083CA         || 		BREQ	armstrong
(0070)  CS-0x016  0x08028         || 		BRN 	opselect			; invalid option; pick new
(0071)                            || ;--------------------------------------------------------------------------------------
(0072)                            || ;- Option 1 : Odd / Even
(0073)                            || ;- Registers Used: R0, R30, R31
(0074)                            || ;--------------------------------------------------------------------------------------
(0075)  CS-0x017  0x26001  0x017  || odd:	TEST	INPUT, 0X01			; Zero flag fliped if Zero in LSB
(0076)  CS-0x018  0x080DB         || 		BRNE	printodd			; print odd branch, otherwise print even
(0077)  CS-0x019  0x35F01         || 		OUT		R31, 0x01			; print 1 if odd
(0078)  CS-0x01A  0x08028         || 		BRN 	opselect
(0079)                     0x01B  || printodd:	
(0080)  CS-0x01B  0x35E01         || 		OUT		R30, 0x01			; print 2 if even
(0081)  CS-0x01C  0x08028         || 		BRN 	opselect
(0082)                            || ;--------------------------------------------------------------------------------------
(0083)                            || ;- Option 2 : Prime Test
(0084)                            || ;- Registers Used: R0, R3, R30, R31
(0085)                            || ;- Registers Inherited: R10, R11, R12, R13
(0086)                            || ;--------------------------------------------------------------------------------------
(0087)  CS-0x01D  0x30000  0x01D  || prime:	CMP 	INPUT, 0X00			; 0 check
(0088)  CS-0x01E  0x08172         || 		BREQ	notprime			; if 0, print not prime
(0089)  CS-0x01F  0x30001         || 		CMP 	INPUT, 0X01
(0090)  CS-0x020  0x08172         || 		BREQ	notprime			; if 1, not prime for some reason
(0091)  CS-0x021  0x36A02         || 		MOV 	DIVISOR, 0X02		; set divisor to 2 to check prime
(0092)  CS-0x022  0x04D01         || 		MOV		DIVIDEND, INPUT		; set up to halve R0
(0093)  CS-0x023  0x08389         || 		CALL 	division
(0094)  CS-0x024  0x04359         || 		MOV 	R3, QUOTIENT		; half of R0
(0095)                     0x025  || primeloop:	
(0096)  CS-0x025  0x04A18         || 		CMP		DIVISOR, R3			; if i (divisor) <= input/2...
(0097)  CS-0x026  0x0A161         || 		BRCC 	isprime
(0098)  CS-0x027  0x08389         || 		CALL	division
(0099)  CS-0x028  0x30C00         || 		CMP 	REMAINDER, 0X00
(0100)  CS-0x029  0x08172         || 		BREQ	notprime
(0101)  CS-0x02A  0x28A01         || 		ADD		DIVISOR, 0X01
(0102)  CS-0x02B  0x08128         || 		BRN 	primeloop
(0103)                     0x02C  || isprime:	
(0104)  CS-0x02C  0x35E02         || 		OUT 	R30, 0X02			; print 1 if prime
(0105)  CS-0x02D  0x08028         || 		BRN 	opselect
(0106)                     0x02E  || notprime:	
(0107)  CS-0x02E  0x35F02         || 		OUT 	R31, 0X02			; print 2 if not prime
(0108)  CS-0x02F  0x08028         || 		BRN 	opselect
(0109)                            || ;--------------------------------------------------------------------------------------
(0110)                            || ;- Option 3 : Perfect Test
(0111)                            || ;- Registers Used: R0, R2, R3, R30, R31
(0112)                            || ;- Registers Inherited: R10, R11, R12, R13
(0113)                            || ;--------------------------------------------------------------------------------------
(0114)                     0x030  || perfect:	
(0115)  CS-0x030  0x36200         || 		MOV 	R2, 0X00			; count variable
(0116)  CS-0x031  0x36300         || 		MOV		R3, 0X00			; sum variable for check
(0117)  CS-0x032  0x04D01         || 		MOV		DIVIDEND, INPUT		; set dividend as input number
(0118)                     0x033  || perfloop:		
(0119)  CS-0x033  0x28201         || 		ADD 	R2, 0X01
(0120)  CS-0x034  0x04200         || 		CMP		R2, INPUT
(0121)  CS-0x035  0x081EA         || 		BREQ	perfcheck
(0122)  CS-0x036  0x04A11         || 		MOV		DIVISOR, R2			; set divisor as count variable
(0123)  CS-0x037  0x08389         || 		CALL	division
(0124)  CS-0x038  0x30C00         || 		CMP		REMAINDER, 0X00
(0125)  CS-0x039  0x0819B         || 		BRNE	perfloop
(0126)  CS-0x03A  0x02310         || 		ADD		R3, R2				; bug- happens an extra time
(0127)  CS-0x03B  0x04200         || 		CMP		R2, INPUT
(0128)  CS-0x03C  0x0A198         || 		BRCS	perfloop
(0129)                     0x03D  || perfcheck:	
(0130)  CS-0x03D  0x04300         || 		CMP 	R3, INPUT			
(0131)  CS-0x03E  0x0820B         || 		BRNE	notperf
(0132)  CS-0x03F  0x35E03         || 		OUT 	R30, 0X03			; print 1 if perfect
(0133)  CS-0x040  0x08028         || 		BRN 	opselect
(0134)                     0x041  || notperf:	
(0135)  CS-0x041  0x35F03         || 		OUT 	R31, 0X03			;- print 2 if not perfect
(0136)  CS-0x042  0x08028         || 		BRN		opselect
(0137)                            || ;--------------------------------------------------------------------------------------
(0138)                            || ;- Option 4 : Fibonacci Location
(0139)                            || ;- Registers Used: R0, R2, R3, R4, R5, R29
(0140)                            || ;--------------------------------------------------------------------------------------
(0141)                     0x043  || fibonacci:	
(0142)  CS-0x043  0x36200         || 		MOV		R2, 0X00			; initialize r2 for loop
(0143)  CS-0x044  0x36300         || 		MOV		R3, 0X00
(0144)  CS-0x045  0x36401         || 		MOV		R4, 0X01			; initialize vars for fibonacci
(0145)  CS-0x046  0x04200         || 		CMP		R2, R0				; check if 0
(0146)  CS-0x047  0x0829A         || 		BREQ	print0
(0147)  CS-0x048  0x3020D         || 		CMP		R2, MAX_FIB			; check if the value goes beyond 255
(0148)  CS-0x049  0x0A2B9         || 		BRCC	print255
(0149)  CS-0x04A  0x28201         || 		ADD		R2, 0X01			; add iteration	
(0150)                     0x04B  || fibloop:	
(0151)  CS-0x04B  0x04200         || 		CMP		R2, R0
(0152)  CS-0x04C  0x082AA         || 		BREQ 	printfib
(0153)  CS-0x04D  0x28201         || 		ADD		R2, 0X01
(0154)  CS-0x04E  0x02320         || 		ADD		R3, R4
(0155)  CS-0x04F  0x04521         || 		MOV		R5, R4				; temp value initialize for movement to current val
(0156)  CS-0x050  0x04419         || 		MOV		R4, R3
(0157)  CS-0x051  0x04329         || 		MOV		R3, R5
(0158)  CS-0x052  0x08258         || 		BRN 	fibloop
(0159)                     0x053  || print0:		
(0160)  CS-0x053  0x34304         || 		OUT		R3, 0X04
(0161)  CS-0x054  0x08028         || 		BRN 	opselect
(0162)                     0x055  || printfib:	
(0163)  CS-0x055  0x34404         || 		OUT 	R4, 0X04
(0164)  CS-0x056  0x08028         || 		BRN		opselect
(0165)                     0x057  || print255:	
(0166)  CS-0x057  0x35D04         || 		OUT		R29, 0X04
(0167)                            || ;--------------------------------------------------------------------------------------
(0168)                            || ;- Option 5 : Reverse
(0169)                            || ;- Registers Used: R2, R3
(0170)                            || ;--------------------------------------------------------------------------------------
(0171)                     0x058  || reversed:	
(0172)  CS-0x058  0x04201         || 		MOV 	R2, R0				; move r0 value to r2 for calcs
(0173)  CS-0x059  0x36300         || 		MOV		R3, 0x00			; empty register
(0174)  CS-0x05A  0x36401         || 		MOV		R4, 0x01			; test register
(0175)  CS-0x05B  0x36508         || 		MOV		R5, 0x08
(0176)  CS-0x05C  0x10202         || 		ROL		R2					; First Rotate Left
(0177)                     0x05D  || revloop:
(0178)  CS-0x05D  0x00410         || 		AND		R4, R2				; Select LSB of R2 into R4
(0179)  CS-0x05E  0x00321         || 		OR		R3, R4
(0180)  CS-0x05F  0x10303         || 		ROR		R3
(0181)  CS-0x060  0x10202         || 		ROL		R2
(0182)  CS-0x061  0x36401         || 		MOV		R4, 0x01
(0183)  CS-0x062  0x2C501         || 		SUB		R5, 0x01
(0184)  CS-0x063  0x082EB         || 		BRNE	revloop
(0185)                     0x064  || revprint:
(0186)  CS-0x064  0x34305         || 		OUT		R3, 0x05
(0187)  CS-0x065  0x08028         || 		BRN		opselect
(0188)                            || ;--------------------------------------------------------------------------------------
(0189)                            || ;- Option 6 : Divide
(0190)                            || ;- Registers Used: R10, R11, R12, R13, R29
(0191)                            || ;--------------------------------------------------------------------------------------	
(0192)                     0x066  || divremain:	
(0193)  CS-0x066  0x32AFF         || 		IN 		R10, 0XFF			; get divisor
(0194)  CS-0x067  0x04D01         || 		MOV		DIVIDEND, R0		; set input number as dividend
(0195)  CS-0x068  0x04D50         || 		CMP		DIVIDEND, DIVISOR	; check if divisor greater
(0196)  CS-0x069  0x0A370         || 		BRCS	pgreater
(0197)  CS-0x06A  0x08389         || 		CALL 	division
(0198)  CS-0x06B  0x34B06         || 		OUT 	R11, 0X06
(0199)  CS-0x06C  0x34C07         || 		OUT		R12, 0X07
(0200)  CS-0x06D  0x08028         || 		BRN 	opselect
(0201)                     0x06E  || pgreater:	
(0202)  CS-0x06E  0x35D06         || 		OUT 	R29, 0X06
(0203)  CS-0x06F  0x35D07         || 		OUT		R29, 0X07
(0204)  CS-0x070  0x08028         || 		BRN 	opselect
(0205)                            || ;--------------------------------------------------------------------------------------
(0206)                            || ;- Option 6a : Division Logic
(0207)                            || ;- Registers Used: R10, R11, R12, R13, R29
(0208)                            || ;--------------------------------------------------------------------------------------
(0209)                     0x071  || division:	
(0210)  CS-0x071  0x36B00         || 		MOV		QUOTIENT, 0X00		; quotient value
(0211)  CS-0x072  0x04C69         || 		MOV 	REMAINDER, DIVIDEND	; make r3 hold input value - becomes remainder
(0212)                     0x073  || divloop:	
(0213)  CS-0x073  0x04C50         || 		CMP 	REMAINDER, DIVISOR	; check input value to divisor
(0214)  CS-0x074  0x0A3C0         || 		BRCS 	divret
(0215)  CS-0x075  0x02C52         || 		SUB		REMAINDER, DIVISOR
(0216)  CS-0x076  0x28B01         || 		ADD		QUOTIENT, 0X01
(0217)  CS-0x077  0x08398         || 		BRN 	divloop
(0218)  CS-0x078  0x18002  0x078  || divret:	RET
(0219)                            || ;--------------------------------------------------------------------------------------
(0220)                            || ;- Option 7 : Armstrong Number
(0221)                            || ;- Registers Used: R0, R2, R7, R30, R31
(0222)                            || ;- Registers Inherited: R3, R4, R5, R6, R10, R11, R12, R13
(0223)                            || ;--------------------------------------------------------------------------------------
(0224)                     0x079  || armstrong:	
(0225)  CS-0x079  0x04701         || 		MOV		R7, R0				; Save Copy of Number
(0226)  CS-0x07A  0x36200         || 		MOV		R2, 0x00			; Clear R2 (Sum)
(0227)  CS-0x07B  0x36A0A         || 		MOV 	DIVISOR, 0X0A		; Set up Divisor for Armstrong Test
(0228)  CS-0x07C  0x04D01         || 		MOV		DIVIDEND, R0
(0229)                     0x07D  || armloop:
(0230)  CS-0x07D  0x08389         || 		CALL 	division
(0231)  CS-0x07E  0x04D59         || 		MOV		DIVIDEND, QUOTIENT
(0232)  CS-0x07F  0x08449         || 		CALL 	armsum
(0233)  CS-0x080  0x02230         || 		ADD		R2, R6
(0234)  CS-0x081  0x30D00         || 		CMP		DIVIDEND, 0x00
(0235)  CS-0x082  0x083EB         || 		BRNE 	armloop
(0236)                     0x083  || armcheck:	
(0237)  CS-0x083  0x04200         || 		CMP		R2, R0
(0238)  CS-0x084  0x0843B         || 		BRNE 	noarm
(0239)                     0x085  || yesarm:		
(0240)  CS-0x085  0x35E08         || 		OUT 	R30, 0X08
(0241)  CS-0x086  0x08028         || 		BRN 	opselect
(0242)  CS-0x087  0x35F08  0x087  || noarm:	OUT 	R31, 0X08
(0243)  CS-0x088  0x08028         || 		BRN		opselect
(0244)                            || ;--------------------------------------------------------------------------------------
(0245)                            || ;- Option 7a : Armstrong Power Logic
(0246)                            || ;- Registers Used: R3, R4, R5, R6
(0247)                            || ;- Registers Inherited: R12
(0248)                            || ;--------------------------------------------------------------------------------------
(0249)  CS-0x089  0x04361  0x089  || armsum:	MOV		R3, REMAINDER
(0250)  CS-0x08A  0x04461         || 		MOV		R4, REMAINDER		; Power Counter
(0251)  CS-0x08B  0x36500         || 		MOV		R5, 0x00
(0252)  CS-0x08C  0x36600         || 		MOV		R6, 0x00
(0253)                            || 				
(0254)                     0x08D  || sumloop1:
(0255)  CS-0x08D  0x02560         || 		ADD		R5, REMAINDER				
(0256)  CS-0x08E  0x2C301         || 		SUB		R3, 0x01			; Addition Counting
(0257)  CS-0x08F  0x0846B         || 		BRNE 	sumloop1
(0258)                     0x090  || sumloop2:	
(0259)  CS-0x090  0x02628         || 		ADD		R6, R5
(0260)  CS-0x091  0x2C401         || 		SUB		R4, 0x01			; Power Counting
(0261)  CS-0x092  0x08483         || 		BRNE 	sumloop2
(0262)  CS-0x093  0x18002  0x093  || armend:	RET
(0263)                            || 
(0264)                            || 
(0265)  CS-0x094  0x084A0  0x094  || end:	BRN 	end





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
ARMCHECK       0x083   (0236)  ||  
ARMEND         0x093   (0262)  ||  
ARMLOOP        0x07D   (0229)  ||  0235 
ARMSTRONG      0x079   (0224)  ||  0069 
ARMSUM         0x089   (0249)  ||  0232 
BEGIN          0x001   (0043)  ||  
DIVISION       0x071   (0209)  ||  0093 0098 0123 0197 0230 
DIVLOOP        0x073   (0212)  ||  0217 
DIVREMAIN      0x066   (0192)  ||  0067 
DIVRET         0x078   (0218)  ||  0214 
END            0x094   (0265)  ||  0055 0265 
FIBLOOP        0x04B   (0150)  ||  0158 
FIBONACCI      0x043   (0141)  ||  0063 
ISPRIME        0x02C   (0103)  ||  0097 
NOARM          0x087   (0242)  ||  0238 
NOTPERF        0x041   (0134)  ||  0131 
NOTPRIME       0x02E   (0106)  ||  0088 0090 0100 
ODD            0x017   (0075)  ||  0057 
OPSELECT       0x005   (0052)  ||  0070 0078 0081 0105 0108 0133 0136 0161 0164 0187 
                               ||  0200 0204 0241 0243 
PERFCHECK      0x03D   (0129)  ||  0121 
PERFECT        0x030   (0114)  ||  0061 
PERFLOOP       0x033   (0118)  ||  0125 0128 
PGREATER       0x06E   (0201)  ||  0196 
PRIME          0x01D   (0087)  ||  0059 
PRIMELOOP      0x025   (0095)  ||  0102 
PRINT0         0x053   (0159)  ||  0146 
PRINT255       0x057   (0165)  ||  0148 
PRINTFIB       0x055   (0162)  ||  0152 
PRINTODD       0x01B   (0079)  ||  0076 
REVERSED       0x058   (0171)  ||  0065 
REVLOOP        0x05D   (0177)  ||  0184 
REVPRINT       0x064   (0185)  ||  
SUMLOOP1       0x08D   (0254)  ||  0257 
SUMLOOP2       0x090   (0258)  ||  0261 
YESARM         0x085   (0239)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
MAX_FIB        0x00D   (0023)  ||  0147 


-- Directives: .DEF
------------------------------------------------------------ 
DIVIDEND         r13   (0034)  ||  0092 0117 0194 0195 0211 0228 0231 0234 
DIVISOR          r10   (0031)  ||  0091 0096 0101 0122 0195 0213 0215 0227 
INPUT            r0    (0025)  ||  0075 0087 0089 0092 0117 0120 0127 0130 
MAX              r29   (0029)  ||  0047 
ONE              r30   (0027)  ||  0045 
OPTION           r1    (0026)  ||  
QUOTIENT         r11   (0032)  ||  0094 0210 0216 0231 
REMAINDER        r12   (0033)  ||  0099 0124 0211 0213 0215 0249 0250 0255 
TWO              r31   (0028)  ||  0046 


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
