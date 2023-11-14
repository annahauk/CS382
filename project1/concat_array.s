
/**
 * Name: Anna Hauk
 * Pledge: I pledge my honor that I have abided by the stevens honor system.
 */

/*

function prototype: char* concat_array(unsigned long int*, unsigned long int);

   create a stack frame to save registers x0 through X4
   since they are all used in this routine and the link
   register x30 as well

    +-----------------------------------+
  0 |        saved x0 register          |
    +-----------------------------------+
  8 |        saved X1 register          |
    +-----------------------------------+
 16 |        saved X2 register          |
    +-----------------------------------+
 24 |        saved X3 register          |
    +-----------------------------------+
 32 |        saved X4 register          |
    +-----------------------------------+
 40 |        saved X5 register          |
    +-----------------------------------+
 48 |        saved X6 register          |
    +-----------------------------------+
 56 |        saved X7 register          |
    +-----------------------------------+
 64 |        saved x30 link register    |
    +-----------------------------------+

*/

.extern itoascii

.global concat_array

concat_array:  SUB SP, SP, 72           // make a stack frame to hold 6 registers
               STR X0,  [SP,0]          // make a copy of argument x
               STR X1,  [SP,8]          // save off the registers
               STR X2,  [SP,16]
               STR X3,  [SP,24]
               STR X4,  [SP,32]
               STR X5,  [SP,40]
               STR X6,  [SP,48]
               STR X7,  [SP,56]
               STR x30, [SP,64]

               MOV X2, 0                  // X2 running index of integers in array
               MOV X3, X0                 // X3 is a copy of a pointer to the beginning of the array
               MOV X7, 0                  // X7 is an index into the concat_array_outstr for writing
loop:          LDR X0, [X3,X2,lsl#3]      // X0 = array[X2*8], these are 64 bit ints, so the lsl#3 has
               bl itoascii                // the effect of making the index increment by eights

               MOV X4, 0                      // X4 will be a byte index into the source and destination string
               ADR X6, concat_array_outstr    // make X6 point to the spot in concat_array_outstr where the next
               ADD X6, X6, X7                 // byte is supposed to get written

strcpy_loop:   ldrb W5, [X0,X4]               // this copies a byte at a time from the string returned
               CMP X5,0                       // by itoascii to the right spot in the concat_array_outstr string
               beq strcpy_done                // buffer
               STRB W5, [X6,X4]               //
               ADD X4, X4, 1                  // X4 gets incremented to keep track of the copying location in the strings
               ADD X7, X7, 1                  // X7 gets incremented to keep track of which byte index in concat_array_outstr
               b strcpy_loop                  // should get copied to next

strcpy_done:   ADD X2, X2, 1                  // this test of X2 against X1 is to keep
               CMP X2, X1                     // track of of how many integers in the array have
               blt put_space                  // been converted to strings, and as long as we are
               MOV X5, 32                     // not finished put a space character (ascii code 32)
               STRB W5, [X6,X4]               // in between them in concat_array_outstr
               ADD X4, X4, 1                  // and booooooo, the assignment seemed like it
               MOV X5, 0                      // was going to give credit for not having a space
               STRB W5, [X6,X4]               // character on the end, when I saw all my tests failed
               b done                         // i added this extra space character and then the final null
put_space:     MOV X5, 32                     // here we put a space in the right spot in concat_array_outstr
               STRB W5, [X6,X4]               // and then increment the index of where we are at in the concat_array_outstr
               ADD X7, X7, 1                  // and then go and fetch the next integer
               b loop

done:
            ADR X0, concat_array_outstr  // return the address of concat_array_outstr and then
            LDR X1,  [sp,8]              // we restore the original
            LDR X2,  [sp,16]             // registers we saved off on the stack at the beginning
            LDR X3,  [sp,24]             // of the function with the exception
            LDR X4,  [sp,32]             // of restoring X0, since that is being
            LDR X5,  [sp,40]             // used as the return value
            LDR X6,  [sp,48]             //
            LDR X7,  [sp,56]             // 
            LDR x30, [sp,64]             // 
            ADD sp, sp, 72               // increment the stack pointer to
            RET                          // pop our stack frame off the stack
                                         // and then return

.data
    /* Put the converted string into concat_array_outstrer,
       and return the address of concat_array_outstr */
    concat_array_outstr:  .fill 1024, 1, 0
