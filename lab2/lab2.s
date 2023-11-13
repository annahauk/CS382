/*******************************************************************************
* Filename: lab2.s
* Author : Anna Hauk
* Version : 1.0
* Date : 9-19-2023
* Description: write an intro to ARM Assembly to print out "Hello World!"
* Pledge : I pledge my honor that I have abided by the Stevens Honor System.
******************************************************************************/


.text
.global _start

_start:

    //DECLARING DATA
    //label: .type_directive data1, data2, ....
    MOV X0, 1 //Destination (for printing, its value is 1)

    ADR X1, msg //addresses msg data to the X1 register, address of string to be printed
    //don't have to LDR string because it's like a pointer

    ADR X2, msg_len //addresses msg_len to X2 register
    //address of len^
    LDR X2, [X2] //loads the data from msg_len into register X2
    //actual value of len^

    MOV X8, 64 //puts 64 into X8 register for printing
    SVC 0 //runs the program

    //TERMINATE PROGRAM
    MOV X0, 0 //status <- 0
    MOV X8, 93 //exit() is system call #93
    SVC 0 //runs the system call
.data
    msg: .string "Hello World!\n" //creates a char[] for the string
    msg_len: .quad 12 //creates msg_len long to store the length of the string
    //aarch64-linux-gnu-as demo.s -o demo.o  CREATES OBJECT FILE
    //aarch64-linux-gnu-ld demo.o   LINK OBJ FILES TO GENERATE AN EXECUTABLE
    //IF MULTIPLE FILES aarch64-linux-gnu-ld obj1.o obj2.o obj3.o
    //qemu-aarch64 a.out EXECUTE THE OUTPUT (can rename by -0 <newname>)
