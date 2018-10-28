            .text
            .global _start

_start:     LDR R2, =NUMBERS
            LDR R1, N
            LDR R0, RESULT
            PUSH {R0-R2, LR}    // push the used parameter onto the stack and the LR
            BL MAX              
            LDR R3, [SP,]        // get the resulting maximum from the SP
            STR R3, RESULT      // store the maximum into RESULT
            LDR LR, [SP, #12]   // restore LR
            ADD SP, SP, #16     // retore the SP to be empty 
END:        B END

MAX:        PUSH {R0-R3}
            LDR R0, [SP, #16]   // load the result starting at 0
            LDR R1, [SP, #20]   // total number of elements in the array
            LDR R2, [SP, #24]   // location of the array
LOOP:       LDR R3, [R2], #4    // load the content of the address and iterate through the array
            CMP R0, R3          // compare whether the number is greater than the current max
            BGE DECREMENT       // R0>=R3, go to DECREMENT, else
            MOV R0, R3          // change the maximum
DECREMENT:  SUBS R1, R1, #1     // decrement the counter
            BGT LOOP            // if counter is greater than 0 then go to the loop
            STR R0, [SP, #16]   // else, iteration is complete and store the max
            POP {R0-R3}        // pop the used registers
            BX LR              




RESULT:     .word 0
N:          .word 7
NUMBERS:    .word 5, 85, 64, 21,
            .word 42, 87, 2