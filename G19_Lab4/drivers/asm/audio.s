        .text
        .equ FIFO_SPACE, 0xFF203044
        .equ LEFT_DATA,	0xFF203048
        .equ RIGHT_DATA, 0xFF20304C
        .global AUDIO_write_ASM

AUDIO_write_ASM:
		PUSH {R1-R5, LR}
		LDR R1, =FIFO_SPACE		// load address data of audio FIFO 
        LDR R4, =RIGHT_DATA
        LDR R5, =LEFT_DATA
		LDRB R2, [R1, #2]		//(audio_ptr + 2) left data
		LDRB R3, [R1, #3]		//(audio_ptr + 3) right data
		CMP R2, #0x1		//1 if data was written to FIFOs
		MOVLT R0, #0        // if bit is filled in the left FIFO then return 0
        BLT END
		CMP R3, #1
		MOVLT R0, #0        // if bit is filled in the right FIFO then return 0
        BLT END
		STR R0, [R4]
        STR R0, [R5]        // store the signal into the right and left data spots
        MOV R0, #1          // return 1

END:	POP {R1-R5, LR}
		BX LR				// return to the caller
		
        .end


        

