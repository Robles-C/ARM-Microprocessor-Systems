	AREA Reset, CODE, Readonly
ENTRY

		LDR R0,=0x40000000
		MOV R1, #100
		MOV R2, #0
		MOV R3, #0
		MOV R5, #0
		MOV R6, #1
	
AGAIN 	
		ADDS R9,  R3, R6
		ADC  R8,  R2, R5
		
		STR R8, [R0] 			
		ADD R0, R0, #4
		STR R9, [R0]
		ADD R0, R0, #4
		
		MOV R2, R5			
		MOV R3, R6
		
		MOV R5, R8			
		MOV R6, R9
		
		SUBS R1,R1,#1			
		
		BNE AGAIN
		
stop B stop
	END