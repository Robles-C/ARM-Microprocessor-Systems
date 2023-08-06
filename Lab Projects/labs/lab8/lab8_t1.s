		GLOBAL	user_code
		AREA	reset,CODE,READONLY
;user_code	;this label is neccessary
		
		ENTRY
		IMPORT RTN
		IMPORT cDelay

IO0BASE		EQU	0xE0028000
;IO0PIN		EQU	0
IO0DIR		EQU	0x8
IO0SET		EQU	0x4
IO0CLR		EQU	0xC
;IO0PIN		EQU	0xE0028000		

;Lab 8 stuff
B_var		RN		7
onoff		RN		8

delayone	EQU		0x00061A80 ;1 second dely      //4mil is about 1 second delay for arm
debounce	EQU		0x000186A0	 ;for testing purposes only

user_code;this label is neccessary


PINSEL0		EQU		0xE002C000		;pin function for port 0, equate symbolic name PINSEL0 as address 0xE002C000

									;;Selecting funcion as GPIO by writing all zeros to given address 
			MOV 	r0,#0			;moves #0 into register r0      
			LDR 	r1,=PINSEL0		;puts what is stored in register 0xE002C000 (PINSEL0) in r1 register; CANNOT PUT MOV, outputs error in keil
			STR 	r0,[r1]			;copies value stored in r0 to memory address specified by r1

			B		task3			;<------ ENABLE FOR TASKS ONLY 


;---------------------------------------------------------------------------------------------------------			
;Task1 								;Turn on lights using delay from another file
			
			;Initially Assigning B
			MOV	B_var,#0
			
			;set IODIRECTION
			BL		setIODIR
										;;Selecting signal direction of each port pin, we put '1' in each to bit to make it an output pin
			;MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			;LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			;STR		r0, [r1,#IO0DIR]	;copies value stored in r0 (0x0000BF00) to memory address of r1

			BL 		clrset
								
task1		
			CMP 	B_var,#8		;B_var = 8 BEQ next loop for task 2
			BEQ		task2		
			
turnLow								
			LDR		r5,=delayone	;delaying onesec
			BL		RTN				;branching to external file delay_arm.s
									;for logical shift
			LDR		r0,=0x00000100	;binary 100000000 (bit 8)
			LSL		r0,B_var		;Logical shift left of B_var
			
			LDR		r1,=IO0BASE		;forcing low
			STR		r0,[r1,#IO0CLR]			
			
			ADD		B_var,B_var,#1	;+1 B_var		
			
			B		task1



;---------------------------------------------------------------------------------------------------------	
task2				;same as task 1 in C delay
			
			;set IODIRECTION
			BL		setIODIR
			;initally clearing so all lights are back off from task1
			BL		clrset
			;initally setting B_var to zero
			MOV		B_var,#0

turnLow2
			CMP		B_var, #8			;
			BEQ 	endref
			
			LDR		r0,=0x00000100	;binary 100000000 (bit 8)						
			LSL		r0,B_var		;Logical shift left of B_var
			
			LDR		r1,=IO0BASE		;forcing low
			STR		r0,[r1,#IO0CLR]	
			
			LDR		r0,=delayone
			BL		cDelay			;delay subroutine here
			
			ADD		B_var,B_var,#1	;+1 B_var		
			
			CMP		B_var, #8			;
			BEQ 	endref
			
			B 		turnLow2


;---------------------------------------------------------------------------------------------------------
task3
			BL		clrset
			
			LDR 	r0,LEDPINS		;Assigning output for all pins except pin 14 (binary 1011111100000000)
			LDR		r1,=IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0,[r1,#IO0DIR]			;copies value stored in r0 (0x0000BF00) to memory address of r1

			BL 		clrset

sts14						
			;Checking pin14 status
			LDR 	r0,=IO0BASE		;also IO0PIN!
			LDR		r9,[r0]
			TST		r9,#0x00004000	;testing if pin 14 (binary 100000000000000) is a zero (AND operation)
			BEQ		onoff_b					
			B		sts14			

on4led		
			LDR 	r0,=0xF00
			LDR		r1,=IO0BASE		;forcing low, LED ON
			STR		r0,[r1,#IO0CLR]	
			MOV		onoff, #1
			B		rst14

onoff_b					
			LDR		r5,=debounce				;<----- debouncing loop
LP			SUBS	r5,#1
			BNE		LP
			
			TST		onoff,#1
			BEQ		on4led
			B		off4led

off4led		
			LDR 	r0,=0xF00
			LDR		r1,=IO0BASE		;forcing high, LED OFF
			STR		r0,[r1,#IO0SET]	
			MOV		onoff, #0



rst14			;Set Pin 14 to 1 again
			;Assigns ALL PINS to Input/Output, not sure why this needs to be done 
			LDR	r0,=0x0000FF00
			LDR	r1,=IO0BASE
			STR	r0,[r1,#IO0DIR]				;Assigning all as output pins 
		
			LDR	r0,LEDPINS			;setting output for all pins but pin14
			LDR	r1,=IO0BASE
			STR	r0,[r1,#IO0DIR]
			
			B		sts14


clrset		;initally clearing so all lights are back off from task1
			MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0, [r1,#IO0CLR]

			MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0, [r1,#IO0SET]
			
			MOV		PC,lr


setIODIR								;Selecting signal direction of each port pin, we put '1' in each to bit to make it an output pin
			MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0, [r1,#IO0DIR]	;copies value stored in r0 (0x0000BF00) to memory address of r1
			
			MOV		PC,lr



;debounce	
			;LDR		r5,=0x2;FA0
;LP			SUBS	r5,#1
			;BNE		LP
			
			;MOV		PC,lr


endref
stop		B			stop
LEDPINS		DCD	0x0000BF00
			END	; End of code

		
