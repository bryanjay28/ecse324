			.text
			.global _start

_start:		LDR R4, =RESULT		//Point to result location, R4 since it is unused by the rest of the program
			LDR R1, N			//R1 now holds the amount times we want to loop fibonacci
			MOV R0, #0			//initalize the sum
			PUSH {R0,R1, LR}	//Push everything onto the stack
			BL FIB				//calls fibonacci function
			POP {R0, R1, LR}	//pop our value into 	
			STR R0, [R4]		//store R0 (contents) into memory location of R4

END:		B END 			

FIB:		PUSH {R0-R3}		//free up the registers
			MOV R0, #0			//this would be our sum for fibonacci
			LDR R1, [SP, #20]	//that would be the number of times we have to recursively call fibonacci 
			CMP R1, #2			//if less than 2, then return one
			BLT EQUAL			//if 1, then we return 1
								//else then keep calling
			SUB R1, R1, #1		//recursive one less time
			PUSH {R0, R1, LR}	//push onto the stack
			BL FIB				//call the function again
			
			POP {R0,R1,LR}		//after it was computed, get the information back
			MOV R2, R0			//save answer to R2
			SUB R1, R1, #1		//recursive one more time at n-2
			PUSH {R0,R1,LR}		//push on stack
			BL FIB

			POP {R0, R1, LR}	//recover the info
			ADD R0, R2, R0		//add it to answer from previous fibonacci
			B DONE				//done
		

EQUAL:		MOV R0, #1			//set the value to 1
			B DONE				//done

DONE:		STR R0, [SP, #16]	//store our value in 16.
			POP {R0-R3}			//pop everything back in the registers
			BX LR				//branch back


RESULT:		.word	0			//memory assigned for result location
N:			.word	6			//Where we should output the 