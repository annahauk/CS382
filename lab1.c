/*******************************************************************************
* Filename: lab1.c
* Author : Anna Hauk, Nicholas Messina
* Version : 1.0
* Date : 9-12-2023
* Description: write a C program that can print out the binary pattern of any 32-bit integer numbers.
* Pledge : I pledge my honor that I have abided by the Stevens Honor System.
******************************************************************************/

//extracting every bit of the number using bit-wise operations and shifting

#include <stdio.h>
#include <stdlib.h>

//display() prints out one bit
void display(int8_t bit){
    putchar(bit + 48);
}

void display_32(int32_t num) {
    //LSB is 1 if odd
    //display((num >> 31) & 1)
    //2 <<5
    int i = 31;
    while(i >= 0){
        //if(num < 0){
            display((num >> i) & 1);
        //}
        //else
         //   display((num >> (i - 1)) & 1);
        i--;
    }
    printf("\n");
}

int main(int argc, char const *argv[]) {
    display_32(382);
    //00000000000000000000000101111110

    // display_32(64);
    // //00000000000000000000000001000000
    
    // display_32(127);
    // //00000000000000000000000001111111
 
    // display_32(20);
    // //00000000000000000000000000010100
    // display_32(-1);
    // //11111111111111111111111111111111

    // display_32(2147483647);
    // //display_32(4294967296);

    // //display_32(-4294967294);
    // display_32(1);

    // display_32(-2);
    // display_32(-20);
    return 0;
}

//gcc <some_file>.c -o <name_of_output>