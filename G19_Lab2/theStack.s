            .text
            .global _start

_start:     LDR R2, =ARRAY
            
PUSH:       LDR R1, [R2, #4]!   // load the second number from array 
            STR R2, [SP, #-4]!  // store it at the top of the stack and move the stack pointer
            LDR R1, [R2, #4]!   // repear above process
            STR R1, [SP, #-4]!
            LDR R1, [R2, #4]!
            STR R1, [SP, #-4]! // store the last three numbers in the array

POP:        LDR R0, [SP], #4
            LDR R0, [SP], #4
            LDR R0, [SP], #4 // load the same three numbers out of the stack in order from last in first out (reverse)

END:        B END

ARRAY:  .word 0, 10, 9, 48