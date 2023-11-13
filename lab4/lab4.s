/*******************************************************************************
* Filename: lab4.s
* Author : Anna Hauk, Nick Messina
* Version : 1.0
* Date : 10-3-2023
* Pledge : I pledge my honor that I have abided by the Stevens Honor System.
******************************************************************************/


.text
.global _start

_start:

    //TESTING FOR RIGHT TRIANGLE
    ADR X0, side_a   //Load address of side_a
    ADR X1, side_b   //Load address of side_b
    ADR X2, side_c   //Load address of side_c

    LDR X0, [X0]    //loads the data from side_a into register X0
    LDR X1, [X1]    //loads the data from side_a into register X0
    LDR X2, [X2]    //loads the data from side_a into register X0

    //TEST IF c^2 = a^2 + b^2
    MUL X2, X2, X2  //squaring c and putting it back into itself
    MUL X0, X0, X0  //squaring a and putting it back into itself
    MUL X1, X1, X1  //squaring b and putting it back into itself
    ADD X4, X0, X1  // a^2 + b^2 into register X4

    CMP X4, X2  //Compares X4 to X2 (X4 - X2)
    B.EQ print1 //Jumps if right triangle

    //else
    MOV X0, 0       //Puts 0 in the X0 register for printing
    ADR X1, no     //addresses no data to the X5 register, address of string to be printed
    ADR X2, len_no //allocates space for the string through len_no data to the X6 register
    LDR X2, [X2]    //loads length from address to register
    B end       //jumps to end if not equal

    print1:
    MOV X0, 0       //Puts 0 in the X0 register for printing
    ADR X1, yes     //addresses yes data to the X5 register, address of string to be printed
    ADR X2, len_yes //allocates space for the string through len_yes data to the X6 register
    LDR X2, [X2]    //loads length from address to register

    end:
    MOV X8, 64      //puts 64 into X8 register for printing
    SVC 0   //runs the program

    //TERMINATE PROGRAM
    MOV X0, 0 //status <- 0
    MOV X8, 93 //exit() is system call #93
    SVC 0 //runs the system call


exit:
    MOV   X0, 0        // Pass 0 to exit()
    MOV   X8, 93       // Move syscall number 93 (exit) to X8
    SVC   0            // Invoke syscall

.data
    side_a: .quad 3
    side_b: .quad 4
    side_c: .quad 5
    yes: .string "It is a right triangle.\n"
    len_yes: .quad . - yes // Calculate the length of string yes 25
    no: .string "It is not a right triangle.\n"
    len_no: .quad . - no // Calculate the length of string no


    
    //aarch64-linux-gnu-as lab4.s -o lab4.o  CREATES OBJECT FILE
    //aarch64-linux-gnu-ld lab4.o   LINK OBJ FILES TO GENERATE AN EXECUTABLE
    //IF MULTIPLE FILES aarch64-linux-gnu-ld obj1.o obj2.o obj3.o
    //qemu-aarch64 a.out EXECUTE THE OUTPUT (can rename by -0 <newname>)
    