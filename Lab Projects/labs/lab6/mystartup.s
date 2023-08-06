	AREA Reset, CODE, Readonly
				ENTRY ; The first instruction to execute follows
VECTORS
				LDR PC,Reset_Addr
				LDR PC,Undef_Addr
				LDR PC,SWI_Addr
				LDR PC,PAbt_Addr
				LDR PC,DAbt_Addr
				NOP
				LDR PC,IRQ_Addr
				LDR PC,FIQ_Addr
Reset_Addr 		DCD Reset_Handler
Undef_Addr 		DCD UndefHandler
SWI_Addr 		DCD SWIHandler
PAbt_Addr 		DCD PAbtHandler
DAbt_Addr 		DCD DAbtHandler
				DCD 0
IRQ_Addr 		DCD IRQHandler
FIQ_Addr 		DCD FIQHandler
SWIHandler 		B SWIHandler
PAbtHandler 	B PAbtHandler
DAbtHandler 	B DAbtHandler
IRQHandler 		B IRQHandler
FIQHandler 		B FIQHandler
UndefHandler 	B UndefHandler

				IMPORT Reset_Handler
				END