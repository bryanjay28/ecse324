        .text
        .equ	PS2_DATA, 0xFF200100
		.equ	PS2_CONTROL, 0xFF200104
        .global read_PS2_data_ASM

read_PS2_data_ASM:
        PUSH {R1-R2, LR}
        LDR R1, =PS2_DATA
        LDR R2, [R1]        // get the value of stored in keyboard data

        TST R2, #8000       // check the RVALID bit if its 0
        MOVEQ RO, #0        // if RVALID BIT is 0 then return 0 and brancg to end
        BEQ END_PS2
        AND R2, R2, #0xFF   // get the data from the first 8-bits
        STR R2, [R0]        // store the value into the given address
        MOV R0, #1          // return 1 

END_PS2:
        POP {R1-R2, LR}
        BX LR

        .end