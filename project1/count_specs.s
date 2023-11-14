
/**
 * Name: Anna Hauk
 * Pledge: I pledge my honor that I have abided by the stevens honor system.
 */

/*

function prototype: extern unsigned long int count_specs(char*);

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

.global count_specs


.equ ascii_lowercase_a_character, 97
.equ ascii_percent_character, 37

count_specs:
                  SUB SP, SP, 48                   // make a stack frame to hold the registers
                  STR X0, [SP,0]                  // make a copy of argument in x0
                  STR X1, [SP,8]                  // save off the registers
                  STR X2, [SP,16]
                  STR X3, [SP,24]
                  STR X4, [SP,32]
                  STR X30, [SP,40]

                  MOV X1, 0                        // x1 will count the number of %a sequences we have seen
                  MOV X2, 0                        // x2 will be a flag that is 1 if we have seen
                                                   // the previous character be the percent sign, initialize to false
                  MOV X3, 0                        // x3 will be an index to the input string


loop:             LDRB W4, [X0, X3]                // load a character from input string and check if null
                  CMP X4,0                         // if it's null jump to done and return count
                  beq done                         // branch if equal X4 == 0

                  CMP X2, 0                        // check if flag is not set
                  bne flag_set
                  CMP X4, ascii_percent_character  // flag is clear, so check for %
                  bne dont_change_flag
                  MOV X2, 1                        // set the flag

dont_change_flag: b continue

flag_set:         CMP X4, ascii_lowercase_a_character   // flag is set so check if character is the letter a
                  beq increment_count                   // and if so, increment the count and clear the flag
                  CMP X4, ascii_percent_character       // if it's not a lowercase a, but instead a percent
                  bne clear_flag                        // keep the flag set and continue
                  b continue
                  
increment_count:  ADD X1, X1, 1
clear_flag:       MOV X2, 0                             // otherwise, clear the seen % flag and start the search again
continue:         ADD X3, x3, 1                         // increment the string index and loop to run the logic again
                  b loop

done:            MOV X0, X1           // x1 was counting, so copy that into x0 for the return value
                                      // and then start saving registers
                 LDR X1,  [SP,8]      // we restore the original
                 LDR X2,  [SP,16]     // registers we saved off on the stack at the beginning
                 LDR X3,  [SP,24]     // of the function with the exception
                 LDR X4,  [SP,32]     // of restoring x0, since that is being
                 LDR X30, [SP,40]     // used as the return value
                 ADD SP, SP, 48       // increment the stack pointer to
                 RET                  // pop our stack frame off the stack
                                      // and then return


/*
    Declare .data here if you need.
*/