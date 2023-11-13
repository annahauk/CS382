/*******************************************************************************
* Filename: lab3.s
* Author : Anna Hauk, Nyrah Balabanian
* Version : 1.0
* Date : 9-27-2023
* Description: Write an Assembly program to calculate the dot product.
    Then, do a debugging analysis.
* Pledge : I pledge my honor that I have abided by the Stevens Honor System.
******************************************************************************/

.text
.global _start

_start:
    // Load addresses of vec1, vec2, and dot into registers
    ADR X1, vec1_start  // Load addresses of vec1 into registers
    ADR X2, vec2_start  // Load addresses of vec2 into registers
    ADR X8, dot_start   // Load addresses of dot into registers

    // Load the elements of vec1 and vec2, and calculate the dot product
    LDR X3, [X1]        // Load vec1[0]
    LDR X4, [X2]        // Load vec2[0]
    MUL X5, X3, X4      // Multiply and store in X5

    LDR X3, [X1, 8]     // Load vec1[1]
    LDR X4, [X2, 8]     // Load vec2[1]
    MUL X6, X3, X4      // Multiply and store in X6

    LDR X3, [X1, 16]    // Load vec1[2]
    LDR X4, [X2, 16]    // Load vec2[2]
    MUL X7, X3, X4      // Multiply and store in X7

    // Sum up the results
    ADD X7, X7, X5      // X7 = X7 + X5
    ADD X7, X7, X6      // X7 = X7 + X6


    STR X7, [X8]        // Store the result in dot

    // Terminate the program
    MOV X0, 0            // status <- 0
    MOV X8, 93           // exit() is system call #93
    SVC 0                // Run the system call

.data
vec1_start: .quad 10, 20, 30
vec2_start: .quad 1, 2, 3
dot_start: .quad 0

//aarch64-linux-gnu-as lab3.s -g -o lab3.o   
//aarch64-linux-gnu-ld lab3.o -lc
//qemu-aarch64 -g 1234 -L /usr/aarch64-linux-gnu a.out


//gdb
//
