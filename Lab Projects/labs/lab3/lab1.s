	GLOBAL Reset_Handler
	AREA mycode, CODE, Readonly
Reset_Handler
 ;;task 1
 ;;EQU = variables must be shifted all the way to the left
;ADD1 EQU 0x40000008
;ADD2 EQU 0x4000000C
;ADD3 EQU 0x40000000
;VAL1 EQU 0x33221100
	;;moves 0xFB into R5
	;MOV R5, #0xFB
	;;need to use ldr because 0x33221100 is too big for move
	;;moves val1 into r2
	;LDR R2, =VAL1
	;;moves ADD1 into R1
	;LDR R1, =ADD1
	;;moves ADD2 into R3
	;LDR R3, =ADD2
	;;STORES value in r5 into memory location r1
	;STR R5, [R1]
	;;STORES value in r2 into memory location r3
	;STR R2, [R3]
	;; loads register with add3 into r6
	;LDR R6, =ADD3
	;;loads val2 into r7
	;LDR R7, VAL2
	;;copies r7 into memory location r6
	;STR R7, [R6] 
;VAL2 DCD 0x44663377

 ;;task2
 ;;variables
;ADD1 EQU 0x40000010
;ADD2 EQU 0x40000014
;VAL1 EQU 0xfb
;VAL2 EQU 0x33221100
;VAL3 EQU 0x44663377
	
	;;moves val1 into r0
	;MOV R0, #VAL1
	;;moves val 2 into r1
	;; needs ldr instead of mov because val 2 is too big for mov
	;LDR R1, =VAL2
	;;moves address1 into r2
	;LDR R2, =ADD1
	;;adds r1+r0 and puts it in r3
	;ADD R3, R1, R0
	;; stores r3 into address in r2
	;STR R3, [R2]
	;; stores val3 in r4
	;LDR R4, =VAL3
	;; subtracts r1 from r4 and puts it into r5
	;SUB R5, R4, R1
	;; stores address 2 location into r6
	;LDR R6, =ADD2
	;;stores subtraction result into r6 which is add2
	;STR R5, [R6]
	
;task 3
ADD1 EQU 0x40000014
VAL1 EQU 0xFBBBBB
	
	;stores address 1 into r0
	MOV R0, ADD1
	;moves val 1 into r1
	MOV R1, #VAL1
	; shifts val 1 right 4 times
	ROR R1, #4
	; stores the shift into address1
	STR R1, [R0]
	
stop B stop
	END 