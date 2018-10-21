            .text
            .global _start

_start:     LDR R0, NUMBER  // load the number for the fibobacci calculation
            MOV R3, #0
            PUSH {LR}   // store the registers used
            BL FIB          // link to fibonacci call
            POP {LR}

FIB:        CMP R0, #2
            MOVEQ MOV R4, #1
            MOVEQ PC, LR
            SUB R0, R0, #1
            PUSH {R0, LR}
            BL FIB

            SUB R0, R0, #1
            PUSH {R0, LR}
            BL FIB

            ADD R3, R3, R4
            POP {R0, LR}
            BX LR

END:        B END


NUMBER:     .word 8