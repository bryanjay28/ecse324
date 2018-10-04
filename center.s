			.text
			.global _start

_start:		LDR R4, =RESULT		// holds the average location
			LDR R3, [R4, #4]	// holds the total number of values
			ADD R2, R4, #8		// holds the address of the first number in the list
			LDR R0, [R2]		// holds the total of the numbers

TOTAL:		SUBS R3, R3, #1		// decrement the counter
			BEQ ENDTOTAL		//end loop if counter had reached 0
			ADD R2, R2, #4
			LDR R1, [R2]
			ADD R0, R0, R1
			B TOTAL

ENDTOTAL: 	LDR R3, [R4, #4]	// holds the total number of values
			B AVERAGE

AVERAGE:	LSR R3, R3, #1		// divide by 2 until counter hits 0
			CMP R3, #0	
			BEQ ENDAVERAGE	 	// if 0, then divide by 2 one more time then do substraction
			LSR R0, R0, #1		// divide the total numbers by 2 to get avg
			B AVERAGE

ENDAVERAGE:	STR R0, [R4]
			ADD R2, R4, #8		// holds the address of the first number in the list
			LDR R3, [R4, #4]	// holds the total number of values
			B SUBS_AVG

SUBS_AVG:	SUBS R3, R3, #1 	// decrement counter
			BEQ END				// if 0, then the numbers have been cycled through
			LDR R5, [R2]		// load the value of the number
			SUBS R5, R5, R0		// take the number - avg
			STR R5, [R2]		// store the new value
			ADD R2, R4, #4		// R2 holds the address of the next number 
			B SUBS_AVG


END: 		B END

RESULT:	 .word 0 // memory assigned for the result location 
N:		 .word 8 // number of entrues in the list 
SIGNAL:  .word 4, 5, 3, 6 //the list data
		 .word 1, 8, 6, 7