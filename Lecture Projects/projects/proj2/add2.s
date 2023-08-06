	;AREA Reset, CODE, Readonly
;ENTRY

;NUM1P1  EQU 0x07770000
;ADD0    EQU 0x40000000

	;LDR R1, =NUM1P1
	;MOV R3, R1
	;LDR R2, =ADD0
	;STR R3, [R3]

;stop B stop
	;END


;;num1
;NUM1P1  EQU 0x00000007
;NUM1P2  EQU 0x55B0BDD8
;NUM1P3  EQU 0xFA9946C1
;;NUM1P4  EQU 0xFA9946C1
;;num2
;NUM2P1  EQU 0x0000000B
;NUM2P2  EQU 0xDE2AB8CE
;NUM2P3  EQU 0xCAFB7902
;;NUM2P4  EQU 0x66667777

		;; NUM1P1       			   NUM1P2			               NUM1P3                    NUM1P4
	    ;;+NUM2P1       			   NUM2P2			               NUM2P3                    NUM2P4
	    ;; ADC ADDS WITH CARRY      ADCS awc and updates c flag    ADDS and updates c flag    ADDS and updates c flag
	
	;LDR  R1, =NUM1P1
	;LDR  R2, =NUM1P2
	;LDR  R3, =NUM1P3
	;;LDR  R4, =NUM1P4
	;LDR  R5, =NUM2P1
	;LDR  R6, =NUM2P2
	;LDR  R7, =NUM2P3
	;;LDR  R8, =NUM2P4
	
	
	;ADDS R9,  R1, R5
	;ADCS R10, R2, R6
	;ADC  R12, R4, R8
	
	
;;0000001233DB76A6C594BFC3
	
;stop b stop
	;END

	