			.text
			.global _start

_start:		LDR R4, =RESULT		// holds the average location
			LDR R2, [R4, #4]	// holds the total number of values
			LDR R3, R2			// holds the total number of iterations

PRE_ITER: 	SUBS R3, R3, #1		// decrement the total of iterations
			BEQ END
			ADD R0, R4, #8		// holds the address of the first number in the array
			ADD R1, R4, #12		// holds the address of the second number in the array
			LDR R5, [R0]		// holds the value of the first number and second number
			LDR R6, [R1]
			B SORT

SORT:		SUBS R2, R2, #1		// decrement the total number of items in the array
			BEQ PRE_ITER
			CMP R5, R6
			BGT SWAP 			// if R5 > R6, then swap the numbers
			ADD R0, R0, #4		// holds the address of the next number in the array
			ADD R1, R1, #4		// holds the address of the next number in the array
			LDR R5, [R0]		// holds the value of the numbers
			LDR R6, [R1]
			B SORT				// recall sort function

SWAP: 		STR R5, [R1]
			STR R6, [R0]
			ADD R0, R0, #4		// holds the address of the next number in the array
			ADD R1, R1, #4		// holds the address of the next number in the array
			LDR R5, [R0]		// holds the value of the numbers
			LDR R6, [R1]
			B SORT				// return to sorting function

END: 		B END

RESULT:	 .word 0 // memory assigned for the result location 
N:		 .word 8 // number of entrues in the list 
SIGNAL:  .word 4, 5, 3, 6 //the list data
		 .word 1, 8, 6, 7
