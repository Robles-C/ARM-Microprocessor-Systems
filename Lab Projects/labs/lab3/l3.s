		GLOBAL Reset_Handler
		AREA Reset, CODE, Readonly
		ENTRY
Reset_Handler

ADD1 EQU 0x40000000

	MOV R5, #0xBF
	;LDR R0, ADD1
	LDR R1,=ADD1
	LDR R2, ADD2
	LDR R3,= ADD2

ADD2 DCD 0x33221100

stop 	B 	stop
	END
; end must be shifted