

		GLOBAL user_code
		AREA	mycode,CODE,READONLY
user_code

IO0_BASE	EQU	0xE0028000
IO0PIN		EQU	0
IO0DIR		EQU	0x8
IO0SET		EQU	0x4
IO0CLR		EQU	0xC

PINSEL0		EQU		0xE002C000		;pin function for port 0, equate symbolic name PINSEL0 as address 0xE002C000

			MOV 	r0,#0			;moves #0 into register r0      
			LDR 	r1,=PINSEL0		;puts what is stored in register 0xE002C000 (PINSEL0) in r1 register; CANNOT PUT MOV, outputs error in keil
			STR 	r0,[r1]			;copies value stored in r0 to memory address specified by r1
				
			MOV		r2, #0x00000F00	;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-15 gets declared as output 
			LDR		r3, =IO0_BASE
			LDR		r1, =IO0DIR		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r2, [r1,r3]		;copies value stored in r2 (0x0000FF00) to memory address of r1
														
									;Turn all the LEDS OFF
									;instead of using PINSEL0 now we are using something else
;IO0SET		EQU		0XE0028004
	
									;Set certain bits in value register IO0PIN, we select the bit positions with a 1 value (forcing HIGH, turning them OFF)
			;MOV		r0, #0x0000FF00	;moves 0x0000FF00 (binary 1111111100000000) into r0 register. (Pins 8-15)
			LDR		r4, =IO0SET		;puts 0XE0028004 or IO0SET to r1 register
			STR 	r2,[r3,r4]			;copies value stored in r2 to memory address of r3,r4 (ALL LEDS OFF)
			
									;turn them  ON using IO0CLR
;IO0CLR		EQU		0XE002800C
	
									;Clears certain bits in value register IO0PIN, we clear the bit positions with a 1 value (forcing LOW, turning them ON)
			;MOV		r0, #0x0000FF00	;moves 0x0000FF00 (binary 1111111100000000) into r0 register. (Pins 8-15)
			LDR		r5, =IO0CLR		;puts 0XE002800C or IO0CLR to r1 register
			STR 	r2,[r3,r5]			;copies value stored in r2 to memory address of r3,r5 (ALL LEDS ON)
			MOV     r10,#5
LOOP3
			;LOOP begin
			LDR 	r9,=2142856
LOOP		SUBS	r9,r9,#1
			BNE 	LOOP
			;SUBS	r10,r10,#1
									;turn them ON again
			;MOV		r0, #0x0000FF00	;moves 0x0000FF00 (binary 1111111100000000) into r0 register. (Pins 8-15)
			;LDR		r1, =IO0SET		;puts 0XE0028004 or IO0SET to r1 register
			STR 	r2,[r3,r5]			;copies value stored in r2 to memory address of r3,r4 (ALL LEDS OFF)
	
			LDR 	r8,=2142856
LOOP2		SUBS	r8,r8,#1
			BNE 	LOOP2	
									;turn them OFF again
			;MOV		r0, #0x0000FF00	;moves 0x0000FF00 (binary 1111111100000000) into r0 register. (Pins 8-15)
			;LDR		r1, =IO0CLR		;puts 0XE002800C or IO0CLR to r1 register
			STR 	r2,[r3,r4]			;copies value stored in r0 to memory address of r1 (ALL LEDS ON)
			
			SUBS	r10,r10,#1
			CMP		r10,#0
			BEQ 	stop
			B 		LOOP3

							;Clear certain bits in value register IO0PIN, we select the bit positions with a 1 value
			;MOV		r0,	#0x00000003	;moves 0x00000003 (binary 11) into r0 register, so only pins 0 and 1 is  cleared.
			;LDR		r1, =IO0SET		;puts 0XE0028004 or IOSET to r1 register
			;STR		r0,	[r1]		;copies value stored in r0 (0x00000003) to memory address of r1
stop 		B		stop				
			END	; End of code