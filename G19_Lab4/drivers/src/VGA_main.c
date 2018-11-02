#include <stdio.h>

#include "../../drivers/inc/pushbuttons.h"
#include "../../drivers/inc/VGA.h"
#include "../../drivers/inc/slider_switches.h"

void test_char();
void test_byte();
void test_pixel();



void test_char() {
    int x, y;
    char c = 0;

    for(y=0; y<=59; y++) {
        for(x=0; x<=79; x++) {
            VGA_write_char_ASM(x, y, c++);
        }
    }
}

void test_byte() {
    int x, y;
    char c = 0;

    for(y=0; y<=59; y++) {
        for(x=0; x<=79; x+=3) {
            VGA_write_byte_ASM(x, y, c++);
        }
    }
}

void test_pixel() {
    int x, y;
    unsigned short colour = 0;

    for(y=0; y<=239; y++) {
        for(x=0; x<=319; x++) {
            VGA_draw_point_ASM(x, y, colour++);
        }
    }
}

int main() {
    while(1) {
        int read_btn_press = 0xF & read_PB_data_ASM();
        // button 0 is pressed 
		if (0x1 & read_btn_press) {
		    int switch_val = read_slider_switches_ASM();
            if(switch_val != 0x000) {
                test_char();
            } else {
                test_byte();
            }
		// button 1 is pressed 		
        } else if (0x2 & read_btn_press) {
            test_pixel();
		// button 2 is pressed 
		} else if (0x4 & read_btn_press) {
            VGA_clear_charbuff_ASM();
        // button 3 is pressed 
		} else if (0x8 & read_btn_press) {
            VGA_clear_pixelbuff_ASM();
        }
    }
    
    return 0;
}

