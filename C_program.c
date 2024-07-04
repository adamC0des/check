/* 
 * File:   C_program.c
 * Author: adamgodfrey
 *
 * Created on July 3, 2024, 5:32 PM
 */

#include <stdio.h>
#include <stdlib.h>
#include "config.h"
# define _XTAL_FREQ 1000000 
/*
 * 
 */
int main() {
    char sseg[6] = {0xE0, 0xB0, 0x98, 0x8C, 0x86, 0xC2};
    ADCON1 = 0xff;
    
    //port a output so set according
    TRISA = 0x00;
    
    //port b is our input
    TRISB = 0xff;
    int counter1 = 0;
    
    while (1)
    {
        if(PORTB == 0x00){
            PORTA = 0x00;
        }
        else if (PORTB == 0x01){
            while(PORTB == 0x01){
                PORTA = 0x81;
                __delay_ms(500);
                PORTA = 0x00;
        }
        }   
        else if (PORTB == 0x02) {
            // If PORTB is 0x03, cycle through the pattern on PORTA
            int pattern_index = 0;
            while (PORTB == 0x02) {  // Continue cycling as long as PORTB is 0x03
                switch (pattern_index) {
                    case 0:
                        PORTA = 0xE0;
                        break;
                    case 1:
                        PORTA = 0xB0;
                        break;
                    case 2:
                        PORTA = 0x98;
                        break;
                    case 3:
                        PORTA = 0x8C;
                        break;
                    case 4:
                        PORTA = 0x86;
                        break;
                    case 5:
                        PORTA = 0xC2;
                        break;
                    default:
                        break;
                }
                
                pattern_index = (pattern_index + 1) % 6;  // Cycle through patterns 0 to 5
                __delay_ms(500);  // Delay between each pattern change
            }
        }
        else if (PORTB == 0x03) {
            // If PORTB is 0x03, cycle through the pattern on PORTA
            int pattern_index = 0;
            while (PORTB == 0x03) {  // Continue cycling as long as PORTB is 0x03
                switch (pattern_index) {
                    case 0:
                        PORTA = 0xC2;
                        break;
                    case 1:
                        PORTA = 0x86;
                        break;
                    case 2:
                        PORTA = 0x8C;
                        break;
                    case 3:
                        PORTA = 0x98;
                        break;
                    case 4:
                        PORTA = 0xB0;
                        break;
                    case 5:
                        PORTA = 0xE0;
                        break;
                    default:
                        break;
                }
                
                pattern_index = (pattern_index + 1) % 6;  // Cycle through patterns 0 to 5
                __delay_ms(500);  // Delay between each pattern change
            }
        }
        
        
    }
            
            
            
            
    return (EXIT_SUCCESS);
}

