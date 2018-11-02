        .text
        .equ FIFO_SPACE, 0xFF203044
        .equ LEFT_DATA,	0xFF203048
        .equ RIGHT_DATA, 0xFF20304C
        .global AUDIO_write_ASM

AUDIO_write_ASM:
        PUSH {R1-R4, LR}
        LDR R1, =FIFO_SPACE
        LDR R2, =RIGHT_DATA
        LDR R3, =LEFT_DATA
        LDR R4, [R1]        // load address data of audio FIFO
        TST R4, #0xFF000000
        MOVLT R0, #0        // if bit is filled in the left FIFO then return 0
        BLT END
        TST R4, #0x00FF0000
        MOVLT R0, #0        // if bit is filled in the right FIFO then return 0
        BLT END
        STR R0, [R2]
        STR R0, [R3]        // store the signal into ther right and left data spots
        MOV R0, #1          // return 1

END:    POP {R1-R4, LR}
        BX LR               // return to the caller

        .end


        

