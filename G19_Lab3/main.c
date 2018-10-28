#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"

int main () {
	// while(1) {
	// 	int switch_val = read_slider_switches_ASM();
	//	write_LEDs_ASM(switch_val);
	//}

	HEX_flood_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
	return 0;
}
