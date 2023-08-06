		GLOBAL	user_code
		AREA	reset,CODE,READONLY
;user_code	;this label is neccessary

		ENTRY
		IMPORT RTN


SRAM_ADDR   EQU 0x40000800
IO0BASE		EQU	0xE0028000
;IO0PIN		EQU	0
IO0DIR		EQU	0x8
IO0SET		EQU	0x4
IO0CLR		EQU	0xC
;IO0PIN		EQU	0xE0028000		


delayone	EQU		0x1;00061A80  ;second dely      //4mil is about 1 second delay for arm
debounce	EQU		0x000186A0	 ;for testing purposes only

user_code;this label is neccessary

;---------------------------------------------------------------------------------------------------------		
task1
PINSEL0		EQU		0xE002C000		;pin function for port 0, equate symbolic name PINSEL0 as address 0xE002C000

									;;Selecting funcion as GPIO by writing all zeros to given address 
			MOV 	r0,#0			;moves #0 into register r0      
			LDR 	r1,=PINSEL0		;puts what is stored in register 0xE002C000 (PINSEL0) in r1 register; CANNOT PUT MOV, outputs error in keil
			STR 	r0,[r1]			;copies value stored in r0 to memory address specified by r1
			
			;set IODIRECTION
			BL 		setIODIR
			
			;Initial set of LEDs
			BL 		clrset
			
			B		task2


;---------------------------------------------------------------------------------------------------------			
task2 								;Turn on lights using delay from another file
			
			LDR		r5,=delayone
			BL		RTN				;delay subroutine here 
			
			SWI #1
			
			B		task3
			

;---------------------------------------------------------------------------------------------------------			
task3		
			

			LDR		r5,=delayone
			BL		RTN				;delay subroutine here
			SWI #0					;to turn off all lights
			
			LDR		r5,=delayone
			BL		RTN	
			SWI #2					;to turn on first four lights
			
			LDR		r5,=delayone
			BL		RTN				;delay subroutine here
			
			SWI	#3					;to turn on last four lights
			
			LDR		r5,=delayone
			BL		RTN				;delay subroutine here
			
			SWI #0					;turns it all off	
			
			B 		task4
;---------------------------------------------------------------------------------------------------------

task4		
PINSEL1		EQU		0xE002C004
EXTMODE		EQU		0xE01FC148
EXTPOLAR	EQU		0xE01FC14C
EXTINT		EQU		0xE01FC140
VICIntSel   EQU		0xFFFFF00C
VICIntEna	EQU 	0xFFFFF010

			;configure pins
			LDR		R3,=0x301
			LDR		R4,=PINSEL1
			STR		R3,[R4]
			
			;selecting edge sensitivity
			LDR		R3,=0x9
			LDR		R4,=EXTMODE
			STR		R3,[R4]
			
			;choosing signal polarity
			LDR		R3,=0x0
			LDR		R4,=EXTPOLAR
			STR		R3,[R4]
			
			;clearing flags
			LDR 	r3,=0xA
			LDR 	r4, =EXTINT
			STR 	r3, [r4] 
			
			;
			LDR 	r3,=0x20000
			LDR 	r4, =VICIntSel
			STR 	r3, [r4] 
			
			;
			LDR 	r3,=0x24000
			LDR 	r4, =VICIntEna
			STR 	r3, [r4] 
					
			
			B 		endref
			
clrset		;initally clearing so all lights are back off from task1
			MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0, [r1,#IO0CLR]

			MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0, [r1,#IO0SET]
			
			BX		lr

setIODIR								;Selecting signal direction of each port pin, we put '1' in each to bit to make it an output pin
			MOV		r0, #0x0000FF00		;moves 0x0000FF00 (binary 1111111100000000) into r0 register. Pins 8-13,15 gets declared as output and 14 as input 
			LDR		r1, =IO0BASE		;puts 0xE0028008 or IO0DIR to r1 register
			STR		r0, [r1,#IO0DIR]	;copies value stored in r0 (0x0000BF00) to memory address of r1
			
			BX		lr


;;debounce	
			;;LDR		r5,=0x2;FA0
;;LP			SUBS	r5,#1
			;;BNE		LP
			
			;;MOV		PC,lr

endref

stop		B			stop
LEDPINS		DCD	0x0000BF00
			END	; End of code

		
