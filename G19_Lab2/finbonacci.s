			.text
			.global _start

_start:		LDR R4, =RESULT		// load the result address and number value
			LDR R1, NUMBER			
			PUSH {R0, R1, LR}	// push the address and value onto the stack
			BL FIB	
			POP {R0, R1, LR}	// pop the result and its address
			STR R0, [R4]		// store the result

END:		B END 			

FIB:		PUSH {R0-R2}		// push the registers to be used 
			LDR R1, [SP, #16]	// load the index value
			CMP R1, #2			
			MOVLT R0, #1		// if index R1 < 2, then move 1 into R0 and go to the end
			BLT END_FIB		

			SUB R1, R1, #1		// decrement n-1
			PUSH {R0, R1, LR}	// push the values fib index onto the stack
			BL FIB				// Recursive call
			
			POP {R0,R1,LR}		// pop the past fib index into the registers
			MOV R2, R0			// save R2 to be added 
			SUB R1, R1, #1		// decrement for n-2
			PUSH {R0,R1,LR}		// push the values fib index onto the stack
			BL FIB				// recursive call

			POP {R0, R1, LR}	// pop the indexes back into the registers to add in total
			ADD R0, R2, R0		// add tge results 
			B END_FIB

END_FIB:	STR R0, [SP, #12]	// store value into the number spot on the stack
			POP {R0-R2}			// free up the registers 
			BX LR				// link back to _start pop


NUMBER:		.word	6	
RESULT:		.word	0	
