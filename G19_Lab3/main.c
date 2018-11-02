#include <stdio.h>

#include "./drivers/inc/LEDs.h"			//header files
#include "./drivers/inc/slider_switches.h"	// for drivers
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"

int main () {

	
	while(1) {
		int switch_val = read_slider_switches_ASM();
		write_LEDs_ASM(switch_val);
		if(0x200 & switch_val){
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
		} else {
			HEX_flood_ASM(HEX4 | HEX5);
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3);
			int disp_numb = 0xF & switch_val;
			int hex_numb = 0xF & read_PB_data_ASM();
			HEX_write_ASM(hex_numb, disp_numb);
		}
	}
	return 0;
}
