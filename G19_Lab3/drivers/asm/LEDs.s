			.text
			.equ LED_BASE, 0xFF200000
			.global read_LEDs_ASM
			.global write_LEDs_ASM

read_LEDs_ASM:					//this subroutine will load the value at the LEDs memory
			LDR R1, =LED_BASE	//location into R0 and then branch to LR
			LDR R0, [R1]
			BX LR

write_LEDs_ASM:					//this subroutine will store the value in R0 at the
			LDR R1, =LED_BASE	//LEDs memory location, then branch to LR
			STR R0, [R1]
			BX LR

			.end
