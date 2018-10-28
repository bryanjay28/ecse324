            .text
            .global _start

_start:     LDR R0, NUMBER      // load the number for the fibobacci calculation
            PUSH {LR}           // store the registers used
            BL FIB              // link to fibonacci call
            STR R3, RESULTS     // store the final result
            POP {LR}            // Pop the LR
            B END         

FIB:        CMP R0, #2          // compare if index is < 2
            MOVLT R4, #1        // if true move 1 to R4 (value to add)
            MOVLT PC, LR        // if true go to last LR
            SUB R0, R0, #2      
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
RESULT:     .word 0