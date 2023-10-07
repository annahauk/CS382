/*******************************************************************************
* Filename: lab_cond2.s
* Author : Anna Hauk, Nick Messina
* Version : 1.0
* Date : 10-3-2023
* Pledge : I pledge my honor that I have abided by the Stevens Honor System.
******************************************************************************/
.text
.global _start
.extern scanf

_start:
    
    ADR   X0, fmt_str   // Load address of formated string
    ADR   X1, left      // Load &left
    ADR   X2, right     // Load &right
    ADR   X3, target    // Load &target
    BL    scanf         // scanf("%ld %ld %ld", &left, &right, &target);

    ADR   X1, left      // Load &left
    LDR   X1, [X1]      // Store left in X1
    ADR   X2, right     // Load &right
    LDR   X2, [X2]      // Store right in X2
    ADR   X3, target    // Load &target
    LDR   X3, [X3]      // Store target in X3

    //Test if upper bound - target > 0
    //Test if lower bound - target < 0

    //X1 IS LEFT -5
    //X2 IS RIGHT 6 
    //X3 IS TARGET 3

    CMP X2, X3  //(X2 -X3) upper bound - target to see if its greater than 0 //6-3 = 3
    B.GT cont //If (X2 -X3 > 0) continue to check lower bound

    IFno:
    MOV X0, 0       //Puts 0 in the X0 register for printing
    ADR X1, no      //addresses no data to the X5 register, address of string to be printed
    ADR X2, len_no  //allocates space for the string through len_no data to the X6 register
    LDR X2, [X2]    //loads length from address to register

    B end //goes to end to execute

    cont:
    CMP X1, X3 //(X1 -X3) lower bound - target to see if its less than 0
    B.LT IFyes //If (X2 - X3 < 0) then target is within left and right 
    B IFno  //Jumps to IFno to print out the no message

    IFyes:
    MOV X0, 0       //Puts 0 in the X0 register for printing
    ADR X1, yes     //addresses yes data to the X5 register, address of string to be printed
    ADR X2, len_yes //allocates space for the string through len_yes data to the X6 register
    LDR X2, [X2]    //loads length from address to register

    end:
    MOV X8, 64      //puts 64 into X8 register for printing
    SVC 0           //runs the program

exit:
    MOV   X0, 0        // Pass 0 to exit()
    MOV   X8, 93       // Move syscall number 93 (exit) to X8
    SVC   0            // Invoke syscall

.data
    left:    .quad     0
    right:   .quad     0
    target:  .quad     0
    fmt_str: .string   "%ld %ld %ld"
    yes:     .string   "Target is in range\n"
    no:      .string   "Target is not in range\n"
    len_yes: .quad     19
    len_no:  .quad     23


    //aarch64-linux-gnu-as lab_cond2.s -o lab_cond2.o   
    //aarch64-linux-gnu-ld lab_cond2.o -lc
    //qemu-aarch64 -L /usr/aarch64-linux-gnu/ a.out
