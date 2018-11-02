#include <stdio.h>

#include "../inc/audio.h"

int main() {
    int sample = 0;
    // signal = 1's
    int signal = 0x00FFFFFF;

    while(1) {
        // check if board receives signal
        if(AUDIO_write_ASM(signal)) {
            // increment counter
            sample++; 
            if(sample == 240) {
                // reset counter it reaches the end
                sample = 0;
                if(signal == 0x0) {
                    // restore the signal to 1's if it was 0 s before
                    signal = 0x00FFFFFF;
                } else {
                    // put the signal to 0s if it was 1s before
                    signal = 0x0;
                }
            }
        }
    }
    return 0;
}