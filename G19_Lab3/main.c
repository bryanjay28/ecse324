#include <stdio.h>

#include "./drivers/inc/LEDs.h"			//header files
#include "./drivers/inc/slider_switches.h"	// for drivers
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"

int main () {

	
	while(1) {						//send switches state to LEDs in infinite while loop
		int switch_val = read_slider_switches_ASM();  	//load associated switch value
		write_LEDs_ASM(switch_val);			//store it into LEDs memory
		if(0x200 & switch_val){				//if clear button pressed, clear all HEX displays
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
		} else {
			HEX_flood_ASM(HEX4 | HEX5);			//turn on all segments
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3);	//clear HEX 0-3 so you can display 
			int disp_numb = 0xF & switch_val;	
			int hex_numb = 0xF & read_PB_data_ASM();
			HEX_write_ASM(hex_numb, disp_numb);		//write number onto display
		}
	}
	return 0;
}
