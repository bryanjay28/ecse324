			.text
			.global _start

_start:
			LDR R4, =RESULT		// holds the result location
			LDR R3, [R4, #4]	// holds the total number of values
			LDR R5, [R4, #4]	// holds the total number of values
			ADD R2, R4, #8		// holds the address of the first number in the list
			LDR R0, [R4]		// holds the total of the numbers

TOTAL:
			SUBS R3, R3, #1		// decrement the counter
			BEQ AVERAGE			//end loop if counter had reached 0
			ADD R2, R2, #4
			LDR R1, [R2]
			ADD R0, R0, [R1]
			B TOTAL
	
AVERAGE:
			LSR R5, #1
			BEQ AVERAGE 	//if 0, then 
			LSR R0, #1
			B AVERAGE

RESULT:	 .word 0 // memory assigned for the result location 
N:		 .word 7 // number of entrues in the list 
SIGNAL:  .word 4, 5, 3, 6 //the list data
		 .word 1, 8, 6, 2
