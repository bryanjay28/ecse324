	.text
	.equ PIXELBUFF_BASE, 0xC8000000
	.equ CHARBUFF_BASE, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM
		
VGA_clear_charbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =CHARBUFF_BASE

	MOV R0, #0
LOOPX_CHAR:
	MOV R1, #0				// counter for y value reset
	ADD R4, R3, R0			// add the x counter to the address
LOOPY_CHAR:
	ADD R5, R4, R1, LSL #7	// add the y counter shifted by 7 to the address to get point location
	STRB R2, [R5]			 // store 0 into the array to clear
	ADD R1, R1, #1			// increment counter for y
	CMP R1, #60				// // end of array in y is 59
	BLT LOOPY_CHAR
	
	ADD R0, R0, #1			// increment counter for x
	CMP R0, #80				// end of array in y is 79
	BLT LOOPX_CHAR			// return to x counter 

	POP {R4-R5}
	BX LR

VGA_write_char_ASM:
	CMP R0, #0			// check if it is in range, if yes branch out
	BXLT LR
	CMP R1, #0			// check if it is in range, if yes branch out
	BXLT LR
	CMP R0, #80			// check if it is in range, if yes branch out
	BXGE LR
	CMP R1, #60			// check if it is in range, if yes branch out
	BXGE LR
	
	LDR R3, =CHARBUFF_BASE
	ADD R3, R3, R0			// add in the x index to get location along x
	ADD R3, R3, R1, LSL #7	// add in the y index shifted to get location along y
	STRB R2, [R3]			 // store the char into the array
	BX LR

VGA_write_byte_ASM:			// since we are storing a byte now it takes two address points
	CMP R0, #0				// check if it is in range, if yes branch out
	BXLT LR	
	CMP R1, #0				// check if it is in range, if yes branch out
	BXLT LR
	CMP R0, #68			// check if it is in range, if yes branch out
	BXGE LR
	CMP R1, #78			// check if it is in range, if yes branch out
	BXGE LR

	PUSH {LR, R1-R9}
	LDR R5, =ASCII_HEX
	PUSH {R2}			// get the first 4 bits 
	LSR R2, R2, #4
	LDRB R2, [R5, R2]	// load the hex value corresponding to first 4-bits
	BL VGA_write_char_ASM

	POP {R2}
	ADD R0, R0, #1			// increment address value in order to fill the next cell since byte takes two addresses
	AND R2, R2, #0xF			// get the first 4 bits   
	LDRB R2, [R5, R2]		// load the hex value corresponding to first 4-bits
	BL VGA_write_char_ASM
	ADD R0, R0, #1			// increment address value in order to fill the next cell since byte takes two addresses

	POP {LR, R1-R9}
	BX LR

VGA_clear_pixelbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =PIXELBUFF_BASE

	MOV R0, #0
LOOPX_PIXEL:
	MOV R1, #0			 // counter for y value reset
	ADD R4, R3, R0, LSL #1	// add the x counter to the address
LOOPY_PIXEL:
	ADD R5, R4, R1, LSL #10	 // add the y counter shifted by 7 to the address to get point location
	STRH R2, [R5]			 // store 0 into the array to clear
	ADD R1, R1, #1			 // increment counter for y
	CMP R1, #240		   // array in y is from 0-239
	BLT LOOPY_PIXEL
	
	ADD R0, R0, #1		// increment counter for x
	CMP R0, #320			// end of array in x is 319
	BLT LOOPX_PIXEL		// return to x counter 

	POP {R4-R5}
	BX LR

VGA_draw_point_ASM:
	LDR R3, =319
	CMP R0, #0			 // check if it is in range, if yes branch out
	BXLT LR
	CMP R1, #0		 // check if it is in range, if yes branch out
	BXLT LR
	CMP R0, R3		 // check if it is in range, if yes branch out
	BXGT LR
	CMP R1, #239	 // check if it is in range, if yes branch out
	BXGT LR
	
	LDR R3, =PIXELBUFF_BASE
	ADD R3, R3, R0, LSL #1	// add in the x index to get location along x
	ADD R3, R3, R1, LSL #10	// add in the y index shifted to get location along y
	STRH R2, [R3]			// store the char into the array
	BX LR
	
	
ASCII_HEX:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  // 
	.end
/*            .text
            .equ CHARBUFF_BASE, 0x90000000
            .equ PIXELBUFF_BASE, 0x80000000
            .global VGA_clear_charbuff_ASM
            .global VGA_clear_pixelbuff_ASM
            .global VGA_write_char_ASM
            .global VGA_write_byte_ASM
            .global VGA_draw_point_ASM

VGA_clear_charbuff_ASM:
            PUSH {R0-R4, LR}
            LDR R1, =CHARBUFF_BASE
            MOV R2, #0x0
            MOV R3, #0              

LOOPX_CHAR: MOV R0, #0              // counter for y value reset
            ADD R4, R1, R3          // add the x counter to the address

LOOPY_CHAR: ADD R4, R4, R0, LSL #7  // add the y counter shifted by 7 to the address to get point location
            STRB R2, [R4]           // store 0 into the array to clear
            ADD R0, R0, #1          // increment counter for y
            CMP R0, #80             // array in y is from 0-79
            BLT LOOPY_CHAR

            ADD R3, R3, #1          // increment counter for x
            CMP R0, #60             // end of array in y is 59
            BLT LOOPX_CHAR          // return to x counter 
            
            POP {R0-R4, LR}
            BX LR        

VGA_clear_pixelbuff_ASM:
            PUSH {R0-R4, LR}
            LDR R1, =PIXELBUFF_BASE
            MOV R2, #0x0
            MOV R3, #0              

LOOPX_PIXEL:
            MOV R0, #0              // counter for y value reset
            ADD R4, R1, R3, LSL #1  // add the x counter to the address

LOOPY_PIXEL:
            ADD R4, R4, R0, LSL #10 // add the y counter shifted by 7 to the address to get point location
            STRB R2, [R4]           // store 0 into the array to clear
            ADD R0, R0, #1          // increment counter for y
            CMP R0, #240            // array in y is from 0-239
            BLT LOOPY_CHAR

            ADD R3, R3, #1          // increment counter for x
            CMP R0, #320            // end of array in x is 319
            BLT LOOPX_CHAR          // return to x counter 
            
            POP {R0-R4, LR}
            BX LR
            
VGA_write_char_ASM:
            CMP R0, #80             // check if it is in range, if yes branch out
            BXGT LR
            CMP R1, #60             // check if it is in range, if yes branch out
            BXGT LR
            CMP R0, #0             // check if it is in range, if yes branch out
            BXLT LR
            CMP R1, #0             // check if it is in range, if yes branch out
            BXLT LR


            LDR R3, =CHARBUFF_BASE
            ADD R4, R3, R0          // add in the x index to get location along x
            ADD R4, R4, R1, LSL #7  // add in the y index shifted to get location along y
            STRB R2, [R4]           // store the char into the array
            BX LR


VGA_write_byte_ASM:                 // since we are storing a byte now it takes two address points
            CMP R0, #78             // check if it is in range, if yes branch out
            BXGT LR
            CMP R1, #58             // check if it is in range, if yes branch out
            BXGT LR
            CMP R0, #0             // check if it is in range, if yes branch out
            BXLT LR
            CMP R1, #0             // check if it is in range, if yes branch out
            BXLT LR

            PUSH {R1-R5, LR}
            LDR R5, =ASCII_HEX

            PUSH {R2}   
            LSR R2, R2, #4          // get the first 4 bits          
            LDRB R2, [R5, R2]       // load the hex value corresponding to first 4-bits
            LDR R3, =CHARBUFF_BASE
            ADD R4, R3, R0          // add in the x index to get location along x
            ADD R4, R4, R1, LSL #7  // add in the y index shifted to get location along y
            STRB R2, [R4]           // store the char into the array
            POP {R2}
            ADD R0, R0, #1          // increment address value in order to fill the next cell since byte takes two addresses

            AND R2, R2, #0xF     // get the first 4 bits          
            LDRB R2, [R5, R2]       // load the hex value corresponding to first 4-bits
            LDR R3, =CHARBUFF_BASE
            ADD R4, R3, R0          // add in the x index to get location along x
            ADD R4, R4, R1, LSL #7  // add in the y index shifted to get location along y
            STRB R2, [R4]           // store the char into the array

            POP {R1-R5, LR}
            BX LR

VGA_draw_point_ASM:
			LDR R5, =318
            CMP R0, R5             // check if it is in range, if yes branch out
            BXGT LR
            CMP R1, #238             // check if it is in range, if yes branch out
            BXGT LR
            CMP R0, #0             // check if it is in range, if yes branch out
            BXLT LR
            CMP R1, #0             // check if it is in range, if yes branch out
            BXLT LR


            LDR R3, =PIXELBUFF_BASE
            ADD R4, R3, R0, LSL #1  // add in the x index to get location along x
            ADD R4, R4, R1, LSL #10 // add in the y index shifted to get location along y
            STRH R2, [R4]           // store the char into the array
            BX LR


ASCII_HEX:
	        .byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	        //      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F   
	        .end
*/
