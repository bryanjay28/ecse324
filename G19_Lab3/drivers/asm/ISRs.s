	.text
	
	.global A9_PRIV_TIM_ISR
	.global HPS_GPIO1_ISR
	.global HPS_TIM0_ISR
	.global HPS_TIM1_ISR
	.global HPS_TIM2_ISR
	.global HPS_TIM3_ISR
	.global FPGA_INTERVAL_TIM_ISR
	.global FPGA_PB_KEYS_ISR
	.global FPGA_Audio_ISR
	.global FPGA_PS2_ISR
	.global FPGA_JTAG_ISR
	.global FPGA_IrDA_ISR
	.global FPGA_JP1_ISR
	.global FPGA_JP2_ISR
	.global FPGA_PS2_DUAL_ISR

	.global hps_tim0_int_flag
	.global fpga_pb_int_flag

hps_tim0_int_flag:
	.word 0x0

fpga_pb_int_flag:
	.word 0x4

A9_PRIV_TIM_ISR:
	BX LR
	
HPS_GPIO1_ISR:
	BX LR
	
HPS_TIM0_ISR:
	PUSH {LR}

	MOV R0, #0x1
	BL HPS_TIM_clear_INT_ASM

	LDR R0, =hps_tim0_int_flag
	MOV R1, #1
	STR R1, [R0]

	POP {LR}
	BX LR
	
HPS_TIM1_ISR:
	BX LR
	
HPS_TIM2_ISR:
	BX LR
	
HPS_TIM3_ISR:
	BX LR
	
FPGA_INTERVAL_TIM_ISR:
	BX LR
	
FPGA_PB_KEYS_ISR:
	PUSH {LR}
	LDR R1, =0xFF200050		// load the base address
	LDR R2, [R1, #0xC]		// load the edgecap address
	MOV R0, #0xF			// move all 1's to address of edgecapture in order to reset it  
	STR R0, [R1, #0xC]		// clear the edgecap 
	LDR R0, =hps_tim0_int_flag	// load the flag used in example 1 return if a button was pressed 

PB0_CHECK:
	MOV R3, #0x1 			// since one hot encoded button one is at bit 1
	AND R3, R3, R1			// check if it is button 0
	CMP R3, R1				
	BEQ PB1_CHECK
	MOV R2, #0				// return button number that was pressed
	STR R2, [R0]			// store it into the timer flag
	B END_PB

PB1_CHECK:
	MOV R3, #0x2			// encoding for pb 1
	AND R3, R3, R1			// check if button is 1
	CMP R3, R1
	BEQ PB2_CHECK
	MOV R2, #1				// return button number that was pressed
	STR R2, [R0]			// store it into the timer flag
	B END_PB

PB2_CHECK:
	MOV R3, #0x4			// encoding for pb 2
	AND R3, R3, R1			// check if button is 2
	CMP R3, R1
	BEQ PB3_CHECK
	MOV R2, #1				// return button number that was pressed
	STR R2, [R0]			// store it into the timer flag
	B END_PB

PB3_CHECK:
	MOV R2, #1				// return button number that was pressed
	STR R2, [R0]			// store it into the timer flag

END_PB:
	POP {LR}
	BX LR
	
FPGA_Audio_ISR:
	BX LR
	
FPGA_PS2_ISR:
	BX LR
	
FPGA_JTAG_ISR:
	BX LR
	
FPGA_IrDA_ISR:
	BX LR
	
FPGA_JP1_ISR:
	BX LR
	
FPGA_JP2_ISR:
	BX LR
	
FPGA_PS2_DUAL_ISR:
	BX LR
	
	.end
