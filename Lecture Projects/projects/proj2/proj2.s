	;AREA Reset, CODE, Readonly
;ENTRY
;ADD0  EQU 0x40000000
;COUNT  RN R4
;COUNT2 RN R3
		;;load address1 into r1
		;LDR R2,=ADD0
		;MOV COUNT,#12
		;MOV COUNT2,#100
		;MOV R5, #0
		;MOV R6, #1
		;STR R7, [R2]
	
;;first 12 numbers stored in memory using again loop
;AGAIN 	
		;ADD R7, R6, R5
		;MOV R5, R6
		;MOV R6, R7
		;STR R7, [R2]
		;ADD R2, R2,#128

		;SUBS COUNT,COUNT,#1
		
		;BNE AGAIN

		
		

;stop B stop
	;END