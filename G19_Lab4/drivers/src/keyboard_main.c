#include <stdio.h>

#include "../inc/VGA.h"
#include "../inc/ps2_keyboard"

int main() {
    int x = 0, y = 0;
    char *data;
    // clear the VGA display 
    VGA_clear_charbuff_ASM();

    while(1) {
        // if there was an input from the keyboard then it'll return 1, else 0
        if(read_PS2_data_ASM(data)) {
            // if data is not empty write value to display
            if(*data != 0) {
                VGA_write_byte_ASM(x, y, *data);
                // increment x index by 3
                x += 3;
            }
            // when index reaches the end of the array
            if(x > 79) {
                // reset x and increment y to next row
                x = 0;
                y++;
            }
            // when index reaches the end of the array
            if (y > 59) {
                // reset values and clear display
                x = 0, y=0;
                VGA_clear_charbuff_ASM();
            }
        }
    }
    return 0;
}