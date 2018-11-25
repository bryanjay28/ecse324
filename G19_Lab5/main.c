#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

// implicit declarations
int signal(float freq, int time);
float getNote(char *data);
void displayWave(float freq);

// initialize global variables 
int amplitude = 1; // volume
char previous;	// previsou keyboard value
float frequency[8] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};
int pressed[8] = {0, 0, 0, 0, 0, 0, 0, 0};


int main() {
	// setup interrupts with the given int_setup function
	int_setup(1, (int[]){199});

	// initialize timer used to feed generated samples
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 21; //speed of timer 1 1/48000
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	// configuration of the timer 
	HPS_TIM_config_ASM(&hps_tim);

	// initialization of the variables
	float freq; // freq of notes
	char *data;
	int clock = 0; // keeps track of clock time 

	while(1) {
		// read the data from the keyboard
		if(read_ps2_data_ASM(data)) {
			// check if the previous frequency changed
			if(previous != *data) {
				// get the frequency for the note of the keyboard clicks
				freq = getNote(data);
				// draw the wave onto the screen to display the notes played
				displayWave(freq);
				
				// check when the stop code is present to know when key is released
				if(previous == 0xF0) {
					// allow the same key to be clicked simultaneously
					previous = 0;
				} else {
					// else put in the data clicked
					previous = *data;
				}
			}
		}

		// write the audio data to the signal
		audio_write_data_ASM(signal(freq, clock), signal(freq, clock));
		// check interrupt happens 
		if(hps_tim0_int_flag) {
			// increment clock value
			clock++;	
			// reset the clock when it reaches the e
			if(clock > (int) (48000/freq)) {
				clock = 0;
			}
			// reset the interrupt flag back to 0
			hps_tim0_int_flag = 0;
		}
	}
	return 0;
}

// calculate the signal played from wavetable give a time and frequency
int signal(float freq, int time) {
	// calculate the floating value for the index
	float a = (freq*time);
	int b = (int) a/48000;
	float index = a-(b*48000);
	// extract the integer and remainding decimal
	int integer = (int) index;
	float remain = index - integer;

	// calculate the signal by multiplying by the sound amplitude
	float total = (1-remain)*sine[integer] + remain*sine[integer+1];
	return (int) (total*amplitude);
}

// display the wave onto the screen when keys are pressed
void displayWave(float freq) {
	// clear the display before drawing the next wave
	VGA_clear_pixelbuff_ASM();

	// initialize the colour and position
	short colour = 0xFFFFFF;
	int x = 0, y = 0;
	// 48000 us the total sine wave, divide this by the number of x pixels with a frequency of 60 Hx
	int seg = 48000/(320*60/freq);
	// initialize x position 
	int time_pos = 0;

	// iterate through the display to print out the wave
	for(x=0; x<320; x++) {
		// use a sine function in order to calculate the y pixel to draw the pt on 
		y = (int) (amplitude*sine[time_pos]*(10/sine[6000])) + 120;

		// draw calculated point in white
		VGA_draw_point_ASM(x, y, colour);

		// Increment position based on the increment variable. 
		time_pos += seg; 	
		//Resets the sine wave to the beginning of the period. 
		if (seg > 48000) {
			seg -= 48000; 
		} 
	}


}

// return the note associated with its respective key
float getNote(char *data) {
	// initialize the freq variable
	float freq = 0;

	switch(*data) {
		// keyboard for value + gives volume up
		case 0x79:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				amplitude++;
			}
			break;
		// keyboard for value A, plays C
		case 0x7B:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				amplitude--;
			}
			break;
		// keyboard for value A, plays C
		case 0x1C:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[0] = 1;
			} else {
				pressed[0] = 0;
			}
			break;
		// keyboard for value S, plays D
		case 0x1B:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[1] = 1;
			} else {
				pressed[1] = 0;
			}
			break;
		// keyboard for value D, plays E
		case 0x23:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[2] = 1;
			} else {
				pressed[2] = 0;
			}
			break;
		// keyboard for value F, plays F
		case 0x2B:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[3] = 1;
			} else {
				pressed[3] = 0;
			}
			break;
		// keyboard for value J, plays G
		case 0x3B:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[4] = 1;
			} else {
				pressed[4] = 0;
			}
			break;
		// keyboard for value K, plays A
		case 0x42:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[5] = 1;
			} else {
				pressed[5] = 0;
			}
			break;
		// keyboard for value L, plays B
		case 0x4B:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[6] = 1;
			} else {
				pressed[6] = 0;
			}
			break;
		// keyboard for value ;, plays higher C
		case 0x4C:
		// check each previous byte to see if stop code 
			if(previous != 0xF0) {
				pressed[7] = 1;
			} else {
				pressed[7] = 0;
			}
			break;
		default:
		break;
	}
	// cal

	// return calculated frequency
	return freq;
}




