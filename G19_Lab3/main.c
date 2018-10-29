#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"

int main () {

	// initialize timer 1
	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);

	// initialize second timer to check push buttons
	HPS_TIM_config_t hps_tim_pb;

	hps_tim_pb.tim = TIM1;
	hps_tim_pb.timeout = 5000;
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 1;
	hps_tim_pb.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_pb);

	int ms = 0, sec = 0, min = 0, timer_on = 0;
	HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);
	while (1) {
		if (HPS_TIM_read_INT_ASM(TIM0) && timer_on) {
			HPS_TIM_clear_INT_ASM(TIM0);
			// count in increments of 10 ms
			ms += 10;
			// 1000ms = 1s so we increment seconds and reset ms
			if (ms >= 1000){
				ms -= 1000;
				sec++;
			}
			// 1s = 1min so we increment minutes and reset sec
			if (sec >= 60){
				sec -= 60;
				min++;
			}
			// reset minutes if it goes above 60
			if (min >= 60){
				min -= 60;
			}

			// find the appropriate values for the hex displays
			HEX_write_ASM(HEX0, (ms % 100) / 10);
			HEX_write_ASM(HEX1, ms / 100);
			HEX_write_ASM(HEX2, sec % 10);
			HEX_write_ASM(HEX3, sec / 10);
			HEX_write_ASM(HEX4, min % 10);
			HEX_write_ASM(HEX5, min / 10);
		}

		// timer to read push buttons
		if (HPS_TIM_read_INT_ASM(TIM1)){
			HPS_TIM_clear_INT_ASM(TIM1);
			int read_btn_press = 0xF & read_PB_data_ASM();
			// button 0 is pressed (start)
			if (0x1 & read_btn_press){
				// set timer_on to true
				timer_on = 1;
			}
			// button 1 is pressed (stop)
			else if (0x2 & read_btn_press){
				// set timer_on to false
				timer_on = 0;
			}
			else if (0x4 & read_btn_press){
				// reset all values and set timer_on to false
				ms = 0;
				sec = 0;
				min = 0;
				timer_on = 0;
				// reset all the displays to show 0
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);
			}
		}
	}


/*
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
*/
	return 0;
}
