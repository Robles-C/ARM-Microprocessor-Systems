; Standard definitions of Mode bits and Interrupt (I & F) flags in PSR s
Mode_USR 		EQU 	0x10
I_Bit 			EQU 	0x80 ; when I bit is set, IRQ is disabled
F_Bit 			EQU 	0x40 ; when F bit is set, FIQ is disabled

;Defintions of User Mode Stack and Size
USR_Stack_Size 	EQU 	0x00000100
SRAM 			EQU 	0X40000000
Stack_Top 		EQU 	SRAM+USR_Stack_Size

				AREA 	RESET, CODE, READONLY ;make sure RESET is capitalized
				ENTRY
				ARM
				IMPORT user_code

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
	
SWIHandler 		B 		SWIHandler
PAbtHandler 	B 		PAbtHandler
DAbtHandler 	B 		DAbtHandler
IRQHandler 		B 		IRQHandler
FIQHandler 		B 		FIQHandler
UndefHandler 	B 		UndefHandler


Reset_Handler
	;initialize the stack, full descending
				LDR 	SP, =Stack_Top
	; Enter User Mode with interrupts enabled
				MOV 	r14, #Mode_USR
				BIC 	r14,r14,#(I_Bit+F_Bit)
				MSR 	cpsr_c, r14
	;load start address of user code into PC
				LDR 	pc, =user_code
				END