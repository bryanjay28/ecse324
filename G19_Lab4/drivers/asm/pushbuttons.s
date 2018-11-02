			.text
			.equ PB_DATA, 0xFF200050
			.equ PB_MASK, 0xFF200058
			.equ PB_EDGECAP, 0xFF20005C
			.global read_PB_data_ASM
			.global PB_data_is_pressed_ASM
			.global read_PB_edgecap_ASM
			.global PB_edgecap_is_pressed_ASM
			.global PB_clear_edgecp_ASM
			.global enable_PB_INT_ASM
			.global disable_PB_INT_ASM
			
read_PB_data_ASM:
			LDR R1, =PB_DATA
			LDR R0, [R1]		// load the data into R0 
			BX LR				// return data and branch back
			
PB_data_is_pressed_ASM:
			LDR R1, =PB_DATA	
			LDR R1, [R1]		// repeat read_PD_data_ASM
			AND R2, R2, R0
			CMP R2, R0			// compare the values with one another to see if a button was pressed
			MOVEQ R0, #1		// if R2 = R0 move 1 into R0 to return true
			MOVNE R0, #0		// if R2 != R0 move 0 into R0 to return false 
			BX LR
			
read_PB_edgecap_ASM:
			LDR R1, =PB_EDGECAP
			LDR R0, [R1]		// load the data into R0 
			AND R0, R0, #0xF	// return only the edge bits which is the last 4
			BX LR 				// return data and branch back

PB_edgecap_is_pressed_ASM:		
			LDR R1, =PB_EDGECAP	// repeat the process as above except for PB_EDGECAP
			LDR R1, [R1]		
			AND R2, R2, R0
			CMP R2, R0			
			MOVEQ R0, #1		
			MOVNE R0, #0		
			BX LR
			
PB_clear_edgecp_ASM:
			LDR R1, =PB_EDGECAP // load the address
			MOV R0, #0xF		// move all 1's to address of edgecapture in order to reset it 
			STR R0, [R1]
			BX LR
			
enable_PB_INT_ASM:
			LDR R1, =PB_MASK	
			AND R2, R0, #0xF	// we only want the last 4 numbers since there are b
			STR R2, [R1]		// store it back into the PB_MASK to enable
			BX LR			

disable_PB_INT_ASM:
			LDR R1, =PB_MASK
			LDR R2, [R1]		// load all the mask bits
			BIC R1, R1, R0		// clear all the bits corresponding to R0
			STR R1, [R2]		// store it back into the mask to disable
			BX LR				
			
			.end
			
