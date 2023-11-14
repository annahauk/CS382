
/*  
    Name: Anna Hauk
    Pledge: I pledge my honor that I have abided by the Stevens Honor system.
    
    Objective: convert an integer to ASCII, the opposite operation of the one you wrote
    in homework 2. In this task, you can assume all the numbers are unsigned so no need 
    to consider negative numbers. The function is declared as follows:
      char* itoascii(unsigned long int number);
 */
/*  
   function prototype: char* itoascii(unsigned long int x);

   create a stack frame to save registers x0 through x4
   since they are all used in this routine and the link
   register x30 as well

    +-----------------------------------+
  0 |        saved x0 register          |
    +-----------------------------------+
  8 |        saved x1 register          |
    +-----------------------------------+
 16 |        saved x2 register          |
    +-----------------------------------+
 24 |        saved x3 register          |
    +-----------------------------------+
 32 |        saved x4 register          |
    +-----------------------------------+
 40 |        saved x30 link register    |
    +-----------------------------------+

*/



.global itoascii

itoascii:   SUB SP, SP, 48            // make a stack frame to hold 6 registers
            STR X0,  [SP,0]           // Store copy of X0 on the stack
            STR X1,  [SP,8]           // Store copy of X1 on the stack
            STR X2,  [SP,16]          // Store copy of X2 on the stack
            STR X3,  [SP,24]          // Store copy of X3 on the stack
            STR X4,  [SP,32]          // Store copy of X4 on the stack
            STR X30, [SP,40]          // Store return address X30 on the stack

            MOV X2, 0                 // X2 will be used to hold num_digits; Move 0 into X2
            CMP X0, 0                 // if X0 == 0; compares X0 to 0
            bne arg_not_zero          // Branch if NOT EQUAL to arg_not_zero
            MOV X2, 1                 // update X2(num_digits) with 1; if X0 == 0
            b done_num_digits         // branch to done_num_digits

arg_not_zero:                         // if we reach here, we're going to keep
            MOV  X1, 10               // dividing the argument to this function

num_digits_loop:                  
            UDIV X0, X0, X1           // unsigned divide X0 by 10 until we reach a quotient of zero
            ADD X2, X2, 1             // add 1 to X2 (the digit counter: num_digits)
            CMP X0, 0                 // compare X0 to see if it's zero
            bne num_digits_loop       // if X0 != 0 go loop through again

done_num_digits:                      // X2 holding num digits 
            ADR X4, buffer            // store address of the buffer from the .data
            MOV X0, 0                 // move 0 into X0
            // we're gonna make sure that the number string is null terminated by
            //storing a 0 at buffer[X2(num_digits)]
            STRB W0, [X4,X2]          // store X4 offset X2 into W0
            LDR X0, [SP,0]            // load the original argument into X0
                                      // x1 = divisor of 10
                                      // x2 = num_digits
                                      // we will be tracking when x2 reaches -1 (when all digits processed)
            SUB X2, X2, 1             // X2 = X2 - 1
                                    
digit_processing_loop:
            UDIV X3, X0, X1           // x3 will be used to compute the remainder of
            MUL  X3, X3, X1           // x0 when devided by 10
            SUB  X3, X0, X3           // x3 now has the remainder
            ADD  X3, X3, 48           // make ascii character out of remainder by adding
                                      // the equivalent of '0' to the remainder
            STRB W3, [x4,x2]          // store the ascii digit at the right spot
            UDIV X0, X0, X1           // in our buffer and then divide our quotient again
            SUB X2, X2, 1             // so we can keep figuring out the remainder
            CMP X2,0                  // once our digit counter x2 reaches -1
            bge digit_processing_loop // we know we have processed all digits

done:
            adr x0, buffer            // return the address of buffer
            ldr x1,  [sp,8]           // we start restoring the original
            ldr x2,  [sp,16]          // registers we saved off at the beginning
            ldr x3,  [sp,24]          // of the function with the exception
            ldr x4,  [sp,32]          // of restoring x0, since that is being
            ldr x30, [sp,40]          // used as the return value
            add sp, sp, 48            // increment the stack pointer to
            ret                       // pop our stack frame off the stack
                                      // and then return

.data
    /* Put the converted string into buffer,
       and return the address of buffer */
    buffer: .fill 128, 1, 0

