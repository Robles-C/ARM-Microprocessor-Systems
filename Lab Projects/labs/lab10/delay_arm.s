		GLOBAL	RTN
		AREA	mycode,CODE,READONLY
		ENTRY
		;STMFD	sp!,{LR}
		
RTN			SUBS	r5,#1
			BNE		RTN			;jump to given address if not zero			
			MOVEQ	pc,lr
			;LDMFD	sp!,{PC} 	;works without LDMFD and STMFD

		B RTN
		END