            .text
            .global _start

_start:     LDR R0, NUMBER
            PUSH {LR}
            BL FACTORIAL
            STR R0, RESULT
            LDR LR, [SP, #4]!

END:        B END

FACTORIAL:  CMP R0, #0
            MOVEQ R0, #1
            MOVEQ PC, LR
            ADD R1, R0, #0
            SUB R0, R0, #1
            PUSH {R1, LR}
            BL FACTORIAL
            MUL R0, R0, R1
            POP {R1, LR}
            BX LR

NUMBER:     .word 10
RESULT:     .word 0