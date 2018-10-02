		.text
		.global _start

_start:
			LDR R4, =RESULT		// holds the result location
			LDR R3, [R4, #4]	// holds the total number of values
			ADD R2, R4, #8		// holds the address of the first number in the list
			LDR R0, [R4]		// holds the maximum number
			LDR R5, [R4]		// holds the minimum number

LOOP:
			SUBS R3, R3, #1 //decrement the loop counter
			BEQ COMPUTE_STD_DEV //end loop if counter had reached 0
			ADD R2, R2, #4 //R2 points to next number in the list
			LDR R1, [R2] // R1 holds the next number in the list
			CMP R0, R1 //check if it is greater than the maximum
			BGE MIN_LOOP //if no, branch to MIN_LOOP to check if its a min
			MOV R0, R1 //if yes, update the current max
			B LOOP // branch back to the loop

MIN_LOOP:
			CMP R5, R1
			BGE LOOP //if no, branch, to LOOP and continue
			MOV R5, R1 // if yes, update the current min
			B LOOP //branch back to loop

COMPUTE_STD_DEV:
			SUBS R0, R0, R5
			LSR R0, #2
			STR R0, [R4]

END:	B END //infinite loop


RESULT:	 .word 0 // memory assigned for the result location 
N:		 .word 7 // number of entrues in the list 
NUMBERS: .word 4, 5, 3, 6 //the list data
		 .word 1, 8, 2
