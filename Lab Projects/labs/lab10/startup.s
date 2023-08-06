IO0BASE		EQU		0xE0028000
;IO0PIN		EQU		0
IO0DIR		EQU		0x8
IO0SET		EQU		0x4				;(forcing high, lights turn off)	
IO0CLR		EQU		0xC				;(forcing low, so lights are on)
delayone	EQU		0x1;00061A80
;IO0PIN		EQU		0xE0028000	

; Standard definitions of Mode bits and Interrupt (I & F) flags in PSR s
Len_SVC_Stack 	EQU 	0x100 ; # of bytes assigned to the stack in Supervisor mode
Len_FIQ_Stack 	EQU 	0x200 ; # of bytes assigned to the stack in FIQ mode	
Len_IRQ_Stack 	EQU 	0x90  ; # of bytes assigned to the stack in IRQ mode	
Len_UND_Stack 	EQU 	0x80  ; # of bytes assigned to the stack in Undefined mode
Len_ABT_Stack 	EQU 	0x80  ; # of bytes assigned to the stack in Abort mode
Len_SWI_Stack 	EQU 	0x00000200
IRQ_Stack 		EQU 	0x00000300
FIQ_Stack 		EQU 	0x00000400

Mode_USR 		EQU 	0x10 ; Mode bits for USR mode
Mode_SVC 		EQU 	0x13 ; Mode bits for Supervisor mode
Mode_SWI 		EQU 	0x13
Mode_UND 		EQU 	0x1B ; Mode bits for Undefined mode
Mode_IRQ 		EQU 	0x12 ; Mode bits for IRQ mode
Mode_FIQ 		EQU 	0x11 ; Mode bits for FIQ mode
Mode_ABT 		EQU 	0x17 ; Mode bits for ABT mode

;Defintions of User Mode Stack and Size
SRAM_BASE 		EQU 	0x40000000 ; Starting address of the SRAM
I_Bit 			EQU 	0x80 ; when I bit is set, IRQ is disabled	
F_Bit 			EQU 	0x40 ; when F bit is set, FIQ is disabled		
USR_Stack_Size 	EQU 	0x00000100
SRAM 			EQU 	0X40000000
Stack_Top 		EQU 	SRAM+USR_Stack_Size

				AREA 	RESET, CODE, READONLY ;make sure RESET is capitalized
				ENTRY
				ARM
				IMPORT user_code
				IMPORT RTN

VECTORS

				LDR 	PC,Reset_Addr
				LDR 	PC,Undef_Addr
				LDR 	PC,SWI_Addr
				LDR 	PC,PAbt_Addr
				LDR 	PC,DAbt_Addr
				NOP
				LDR 	PC,IRQ_Addr
				LDR 	PC,FIQ_Addr

Reset_Addr 		DCD 	Reset_Handler
Undef_Addr 		DCD 	UndefHandler
SWI_Addr 		DCD 	SWIHandler
PAbt_Addr 		DCD 	PAbtHandler
DAbt_Addr 		DCD 	DAbtHandler
				DCD 	0
IRQ_Addr 		DCD 	IRQHandler
FIQ_Addr 		DCD 	FIQHandler
	
;SWIHandler 		B 		SWIHandler
PAbtHandler 	B 		PAbtHandler
DAbtHandler 	B 		DAbtHandler
;IRQHandler 		B 		IRQHandler
;FIQHandler 		B 		FIQHandler
UndefHandler 	B 		UndefHandler

SWIHandler	
			LDRB	r9,[LR,#-4]
			CMP		r9, #0
			BEQ		turnoff
			CMP		r9, #1
			BEQ		lighton
			CMP		r9, #2
			BEQ		firstfour
			CMP		r9, #3
			BEQ		lastfour
			
turnoff								;turning off ALL LEDs, (forcing a high) (binary 1111111100000000)
			MOV		r0,#0x0000FF00	;LDR for this?
			LDR		r1,=IO0BASE
			STR		r0,[r1,#IO0SET]
			MOVS	PC,LR
			
lighton								;turning on ALL LEDS
			MOV		r0,#0x0000FF00	
			LDR		r1,=IO0BASE
			STR		r0,[r1,#IO0CLR]
			MOVS 	PC, LR

firstfour							
			;LDR R0,[LR,#-3]
			MOV		r0,#0x0000F000	;turns on first 4 (0000)111100000000
			LDR		r1,=IO0BASE
			STR		r0,[r1,#IO0CLR]
			MOVS 	PC, LR
			
lastfour							
			;LDR R0,[LR,#-3]
			MOV		r0,#0x00000F00	;turns on last 4 1111(0000)00000000
			LDR		r1,=IO0BASE
			STR		r0,[r1,#IO0CLR]
			MOVS 	PC, LR

IRQHandler			
			
			MOV		r0,#0x0000F000	;turns on first 4 (0000)111100000000
			LDR		r1,=IO0BASE
			STR		r0,[r1,#IO0CLR]
			LDR		r5,=delayone
			
			BL		RTN
			
			LDR 	r3,=0x1
			LDR 	r4,=0xE01FC140
			STR 	r3, [r4] 
			
			SUBS	pc, lr, #4 ;copy LR_irq - 4 to PC and copy current SPSR to CPSR
			
FIQHandler
			
			MOV		r0,#0x0000F00	;turns on first 4 (0000)111100000000
			LDR		r1,=IO0BASE
			STR		r0,[r1,#IO0CLR]
			LDR		r5,=delayone
			
			BL		RTN
			
			LDR 	r3,=0x8
			LDR 	r4,=0xE01FC140
			STR 	r3, [r4] 
			
			SUBS 	pc, lr , #4 ;copy LR_irq - 4 to PC and copy current SPSR to CPSR
			
Reset_Handler
				
				LDR r0,=SRAM+FIQ_Stack
				MSR CPSR_c,#Mode_FIQ+I_Bit+F_Bit
				MOV sp,r0
				
				LDR r0,=SRAM+IRQ_Stack
				MSR CPSR_c,#Mode_IRQ+I_Bit+F_Bit
				MOV sp,r0
				
				LDR r0,=SRAM+Len_SWI_Stack
				MSR CPSR_c,#Mode_SWI+I_Bit+F_Bit
				MOV sp,r0
				
;take out files that are missing; take out delay in user code;

	;initialize the stack, full descending
				LDR 	SP, =Stack_Top
	; Enter User Mode with interrupts enabled
				MOV 	r14, #Mode_USR
				BIC 	r14,r14,#(I_Bit+F_Bit)
				MSR 	cpsr_c, r14
	;load start address of user code into PC
				LDR 	pc, =user_code
				END