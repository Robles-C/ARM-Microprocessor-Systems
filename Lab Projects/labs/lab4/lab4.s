	GLOBAL Reset_Handler
	AREA mycode, CODE, Readonly

Reset_Handler ;this label is necessary for the first line of your code.

PINSEL0 EQU 0xE002C000 ;pin function selection for port 0,
IO0DIR  EQU 0xE0028008
IO0PIN  EQU 0xE0028000
; hex value 0x1FE0000 represents values of 1 in bits 8-15 of a 32 bit word
OUTPINS EQU 0x40000000
ALLOFF  EQU 0xBFFFFFFF
ALLON   EQU 0x0

	;moves value 0 into r1
	MOV r0, #0
	;loads resigter at location 0xE002C000
	LDR r1, =PINSEL0
	;stores 0 at 0xE002C000
	STR r0,[r1]
	; loads register at location 0xE0028008
	LDR r2, =IO0DIR
	; loads Outpt into r3
	LDR r3, =OUTPINS
	;puts outpt value at 0xE0028008
	STR r3, [r2]
	
	MOV r4, #ALLOFF
	LDR r5, =IO0PIN
	STR r4, [r5]
	

stop B stop ;endless loop to make the program hang
	END ;assembler directive to indicate the end of code
		
