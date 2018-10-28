#include <stdio.h>

// #include "./drivers/inc/LEDs.h"
// #include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"

int main () {
	// while(1) {
	// 	int switch_val = read_slider_switches_ASM();
	//	write_LEDs_ASM(switch_val);
	//}

	HEX_flood_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
	int i, n = 99999;
	for (i=0;i<=n;i++){
		
	}
	HEX_clear_ASM(HEX3 | HEX4 | HEX5);

	HEX_write_ASM(HEX4, 1);

	return 0;
}
