	AREA Reset, CODE, Readonly
	ENTRY
ADD1   EQU 0x40000000
XLOC   EQU 0x40000052
fXLOC  RN  R2
fX     RN  R4
hold   RN  R7
X	   RN  R3
temp   RN  R5
COUNT  RN  R8

    ; uses 0x40000000 as top of stack pointer
    LDR sp,    =ADD1
    LDR fXLOC,  =XLOC
    MOV COUNT, #100
    MOV fX,    #0
	MOV X,     #1
	MOV X,     temp
	MOV hold,  #0

	;STMIA sp!, {r2-r12, lr}
	BL polyFun
	;LDMDB sp!, {r2-r12}


;polynomial function
polyFun 
again
square 	MUL  fX, X, X
		SUBS temp, temp, #1
		BEQ  square
		
		ADD  hold, hold, fX
		MOV  X, temp
		MOV  fX, #0
		
mult 	MOV  fX, X, LSL#1
		ADD  hold, hold, fX
		SUBS X, X, #1
		BEQ  mult
		 
		ADD  hold, hold, #1
		STR  hold, [fXLOC]
		ADD  fXLOC, fXLOC, #4
		MOV  fX, #0
		ADD  X, X, #1
		MOV  X, temp
		
		SUBS COUNT, COUNT, #1
		
		BEQ again
		BX LR

stop B stop
	END
