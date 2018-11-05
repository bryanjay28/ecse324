			.text
			.equ HEX_BASE0, 0xFF200020
			.equ HEX_BASE4, 0xFF200030
			.global HEX_clear_ASM
			.global HEX_flood_ASM
			.global HEX_write_ASM

HEX_clear_ASM:	PUSH {LR}					//turn off all segments of all hex displays passed in the argument
				LDR R1, =HEX_BASE0		// contains the address for displays 0-3
				LDR R2, =HEX_BASE4		// contains the address for displays 4-5
				MOV R3, #6				// counter for bits, 6 possible hex codes
				MOV R4, #1				// compare with each bit to get hex number since one hot encoded
				MOV R6, #0				// clear bit 

LOOP_BOTTOM:	CMP R3, #2					//clears HEX0-3
				BEQ LOOP_TOP
				ANDS R5, R4, R0 		// check which bit is 1 since to get the hex display
				BEQ BOTTOM		// if R5 > 0, then go to clear
				STRB R6, [R1]				

BOTTOM:			LSL R4, #1				// shift #1 bit to the left to check the next bit value
				ADD R1, R1, #1			// increment hex display value
				SUBS R3, R3, #1			// decrement the counter 
				BGT LOOP_BOTTOM			// if the value is > 0, then keep looping

LOOP_TOP:		CMP R3, #0				//clears HEX4-5 compare with 0 to determine end of the loops
				BEQ END					// if 0, go to the end
				ANDS R5, R4, R0			// repeat process from above
				BEQ TOP
				STRB R6, [R2]			// store into address hex_base4

TOP:			LSL R4, #1
				ADD R2, R2, #1			// increment address of hex_base4
				SUBS R3, R3, #1
				BGT LOOP_TOP

END:			POP {LR}
				BX LR

HEX_flood_ASM:	PUSH {LR}					//turn on all segments
				LDR R1, =HEX_BASE0		// contains the address for displays 0-3
				LDR R2, =HEX_BASE4		// contains the address for displays 4-5
				MOV R3, #6				// counter for bits, 6 possible hex codes
				MOV R4, #1				// compare with each bit to get hex number since one hot encoded
				MOV R6, #0x7F				// flood bit 7F = 0111 1111

LOOP_BOTTOM_F:	CMP R3, #2
				BEQ LOOP_TOP
				ANDS R5, R4, R0 		// check which bit is 1 since to get the hex display
				BEQ BOTTOM_F		// if R5 > 0, then go to clear
				STRB R6, [R1]				

BOTTOM_F:		LSL R4, #1				// shift #1 bit to the left to check the next bit value
				ADD R1, R1, #1			// increment hex display value
				SUBS R3, R3, #1			// decrement the counter 
				BGT LOOP_BOTTOM_F		// if the value is > 0, then keep looping

LOOP_TOP_F:		CMP R3, #0				// compare with 0 to determine end of the loops
				BEQ END_F					// if 0, go to the end
				ANDS R5, R4, R0			// repeat process form above
				BEQ TOP_F
				STRB R6, [R2]			// store into address hex_base4

TOP_F:			LSL R4, #1
				ADD R2, R2, #1			// increment address of hex_base4
				SUBS R3, R3, #1
				BGT LOOP_TOP_F

END_F:			POP {LR}
				BX LR

HEX_write_ASM:	PUSH {LR}					//writes numbers on the display
				LDR R2, =HEX_BASE0		// contains the address for displays 0-3
				LDR R3, =HEX_BASE4		// contains the address for displays 4-5
				LDR R7, =HEX_VAL		// contains array of bytes of the bit values for numbers 0-15
				LDRB R8, [R7, R1]		// load the corresponding hex value for the char
				MOV R4, #6				// counter for bits, 6 possible hex codes
				MOV R5, #1				// compare with each bit to get hex number since one hot encoded

LOOP_BOTTOM2:	CMP R4, #2
				BEQ LOOP_TOP2
				ANDS R6, R5, R0 		// check which bit is 1 since to get the hex display
				BEQ BOTTOM2				// if R5 > 0, then go to clear
				STRB R8, [R2]			// store the desired value in to the hex_base0 diaplay

BOTTOM2:		LSL R5, #1				// shift #1 bit to the left to check the next bit value
				ADD R2, R2, #1			// increment hex display value
				SUBS R4, R4, #1			// decrement the counter 
				BGT LOOP_BOTTOM2		// if the value is > 0, then keep looping

LOOP_TOP2:		CMP R4, #0				// compare with 0 to determine end of the loops
				BEQ END2					// if 0, go to the end
				ANDS R6, R5, R0			// repeat process form above
				BEQ TOP2
				STRB R8, [R3]			// store into address hex_base4

TOP2:			LSL R5, #1
				ADD R3, R3, #1			// increment address of hex_base4
				SUBS R4, R4, #1
				BGT LOOP_TOP2

END2:			POP {LR}
				BX LR

HEX_VAL: 		.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x77, 0x7F, 0x39, 0x3F, 0x79, 0x71
				.end


			
			
