		GLOBAL	Reset_Handler
		AREA	mycode,CODE,READONLY
Reset_Handler	;this label is neccessary


Bit14		EQU		0x00004000
PINSEL0		EQU		0xE002C000	
IO0PIN		EQU		0xE0028000
IO0SET		EQU		0XE0028004
IO0DIR		EQU		0xE0028008
IO0CLR		EQU		0XE002800C
A_var		RN		6
B_var		RN		7
C_var		RN		8

Reset
			;Initially Assigning A & B
			MOV	B_var,#0
			MOV	A_var,#10
			MOV	C_var,#0
	;pin function for port 0, equate symbolic name PINSEL0 as address 0xE002C000
	
									;Selecting funcion as GPIO by writing all zeros to given address 
			MOV 	r0,#0			;moves #0 into register r0      
			LDR 	r1,=PINSEL0		;puts what is stored in register 0xE002C000 (PINSEL0) in r1 register; CANNOT PUT MOV, outputs error in keil
			STR 	r0,[r1]			;Selecting signal direction of each port pin, we put '1' in each to bit to make it an output pin
			LDR 	r0,LEDPINS		;Assigning output for all pins except pin 14 (binary 1011111100000000)
			LDR		r1,=IO0DIR		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0,[r1]			;copies value stored in r0 (0x0000BF00) to memory address of r1			
			MOV		r0,#0x0000FF00
			LDR		r1,=IO0CLR
			STR		r0,[r1]
			MOV		r0,#0x0000FF00
			LDR		r1,=IO0SET
			STR		r0,[r1]
			
			;Start a loop
			
			B		Tests			;Infinite loop checking whether pin14 is pressed
			
task1		
			CMP 	B_var,#8		;B_var = 8 BEQ next loop for task 2
			BEQ		task2		
			
			;Checking pin14 status
			LDR 	r0,=IO0PIN
			LDR		r9,[r0]
			TST		r9,#0x00004000	;testing if pin 14 (binary 100000000000000) is a zero (AND operation)
			BEQ		turnLow			;(if above is zero -> turnLow branch
			
Tests
			B		task1
			
turnLow								;clears next light if pin14 pressed
			LDR		r0,=0x00000100	;binary 100000000 (bit 8)
			LSL		r0,B_var		;Logical shift left of B_var
			LDR		r1,=IO0CLR		;forcing low
			STR		r0,[r1]			
			
			ADD		B_var,B_var,#1	;+1 B_var
			
			;Set Pin 14 to 1 again
			;Assigns ALL PINS to Input/Output, not sure why this needs to be done 
			LDR	r0,=0x0000FF00
			LDR	r1,=IO0DIR
			STR	r0,[r1]				;Assigning all as output pins 
			
			CMP	B_var,#7			;;;;;;i guess if it is at 7 which is pin 14 you do the extra case
			BEQ	Case
			
			LDR	r0,LEDPINS			;setting output for all pins but pin14
			LDR	r1,=IO0DIR
			STR	r0,[r1]
			
			B	Tests
		;When B = 8/ all lights are on 
		
task2		;Checking pin14 status for next button press to start Flashlights
			
			;Set Pin 14 to 1 again
			;Assigns ALL PINS to Input/Output, not sure why this needs to be done 
			LDR	r0,=0x0000FF00
			LDR	r1,=IO0DIR
			STR	r0,[r1]				;Assigning all as output pins 

check14			
			LDR	r0,LEDPINS			;setting output for all pins but pin14
			LDR	r1,=IO0DIR
			STR	r0,[r1]
			
			LDR 	r0,=IO0PIN
			LDR		r9,[r0]
			TST		r9,#0x00004000
			

			
			BEQ		addone			;(if above is zero -> turnLow branch
			
			LDR 	r10,=200000
LOOP2		SUBS	r10,r10,#1
			BNE 	LOOP2
			
			B		check14
			
addone		
			ADD	B_var,B_var,#1
FlashLights

		MOV	r0,#0x0000FF00		;forcing high with IO0SET to turn off all LEDS
		LDR	r1,=IO0SET
		STR	r0,[r1]
		
		ADD		C_var,C_var,#1
		CMP		C_var,#5
		BEQ		task2b
		
		B	FlashLights		

task2b	;checking if B_var=10 then end
		ADD	B_var,B_var,#1		
		CMP	B_var,A_var
		B	stop
		
Case
		LDR r0,=IO0PIN		;puts 0xE0028000 or IO0PIN to r0 register
		LDR	r2,[r0]			;whats stored in memory address of r0, into register r2
		ORR	r1,r2,#Bit14	;r1=r2 or 0x00004000
		STR	r1,[r0]			;r1 is stored into memory address of r0
		
		LDR	r0,LEDPINS		;load 0x0000BF00 into r0 ((binary 1011111100000000)
		LDR	r1,=IO0DIR		;puts 0xE0028008 or IO0DIR to r1 register
		STR	r0,[r1]			;r0 is stored into memory address of r1
		B	Tests
			
			
			
			
stop		B	stop
LEDPINS		DCD	0x0000BF00
			END	; End of code