/**
 * Name: Anna Hauk
 * Pledge: I pledge my honor that I have abided by the stevens honor system.
 */

/*
   Please test my code for more than 3 array var args!!!!
*/

.global pringle
.global find_percent_a
.extern count_specs
.extern concat_array

/*
    char *mymemcpy ( char* destination, char* source, unsigned long int num );
    copies num bytes from source to destination
    return value is destination

*/
mymemcpy: 
           SUB SP, SP, 48
           STR X0,  [SP,0]
           STR X1,  [SP,8]
           STR X2,  [SP,16]
           STR X3,  [SP,24]
           STR X4,  [SP,32]
           STR x30, [SP,40]
           MOV X3,0

memcpy_loop:
           CMP X2, 0
           beq memcpy_done
           LDRB w4, [X1,X3]
           STRB w4, [X0,X3]
           ADD X3, X3, 1
           SUB X2, X2, 1
           b memcpy_loop

memcpy_done:

           LDR X0,  [SP,0]
           LDR X1,  [SP,8]
           LDR X2,  [SP,16]
           LDR X3,  [SP,24]
           LDR X4,  [SP,32]
           ADD SP, SP, 48
           RET


/*
    unsigned long int find_percent_a(char *STR, unsigned long int start_index);

    the function does expect the %a string to appear at least once starting
    anywhere from the start_index onwards

    STR is the string to search for %a in
    start_index = the starting position in the string where to look for %a
    return: the index where %a is found
*/
.equ ascii_lowercase_a_character, 97
.equ ascii_percent_character, 37

find_percent_a:

           SUB SP, SP, 48
           STR X0,  [SP,0]
           STR X1,  [SP,8]
           STR X2,  [SP,16]
           STR X3,  [SP,24]
           STR X4,  [SP,32]
           STR x30, [SP,40]

                                            // X1 is already the start index
           MOV X2, 0                        // X2 will be a flag that is 1 if we have seen
                                            // the previous character be the percent sign, initialize to false
                                            // X3 will be to just hold a character, so a temp register
           MOV X4, X1                       // X4 will the index of the % character
fp_loop:   
           LDRB w3, [X0, X1]                // load a character from input string and check if null
           CMP X3,0                         // if it's null jump to done and return count
           beq fp_done

           CMP X2, 0                        // check if flag is not set
           bne flag_set
           CMP X3, ascii_percent_character  // flag is clear, so check for %
           bne dont_change_flag
           MOV X2, 1                        // set the flag
           MOV X4, X1                       // point X4 at the index of the percent sign

dont_change_flag:

           b continue

flag_set:  CMP X3, ascii_lowercase_a_character   // flag is set so check if character is the letter a
           beq fp_done                           // and if so, increment the count and clear the flag
           CMP X3, ascii_percent_character       // if it's not a lowercase a, but instead a percent
           bne clear_flag                        // keep the flag set and continue
           MOV X4, X1
           b continue
clear_flag:
           MOV X2, 0                           // otherwise, clear the seen % flag and start the search again
continue:  ADD X1, X1, 1                       // increment the string index and loop to run the logic again
           b fp_loop

fp_done:   MOV X0, X4

           LDR X1,  [SP,8]
           LDR X2,  [SP,16]
           LDR X3,  [SP,24]
           LDR X4,  [SP,32]
           LDR x30, [SP,40]
           ADD SP, SP, 48
           RET

mystrlen:  SUB SP, SP, 32
           STR X0,  [SP,0]
           STR X1,  [SP,8]
           STR X2,  [SP,16]
           STR x30, [SP,24]

           MOV X1,0

mystrlen_loop:
           LDRB w2,[X0,X1]
           CMP X2,0
           beq mystrlen_done
           ADD X1, X1, 1
           b mystrlen_loop

mystrlen_done:
           MOV X0, X1
           LDR X1,  [SP,8]
           LDR X2,  [SP,16]
           LDR x30, [SP,24]
           ADD SP, SP, 32
           RET


myputs:    SUB SP, SP, 48
           STR X0,  [SP,0]
           STR X1,  [SP,8]
           STR X2,  [SP,16]
           STR X3,  [SP,24]
           STR X8,  [SP,32]
           STR x30, [SP,40]

           bl mystrlen
           MOV X3, X0        // make copy of string length in X3 in case svc call destroys X0

           MOV X0, 1
           LDR X1, [SP,0]
           MOV X2, X3
           MOV X8, 64
           svc 0             // output the characters

           MOV X0, X3        // make strlength return value

           LDR X1,  [SP,8]
           LDR X2,  [SP,16]
           LDR X3,  [SP,24]
           LDR X8,  [SP,32]
           LDR x30, [SP,40]
           ADD SP, SP, 48
           RET

/*
    Here is the stacking and where things are situated.

    variable                                stack loc  register

    char *format_string;                              [SP,0]    X0
                                                      [SP,8]    X8  (saved)
                                                      [SP,16]   x30 link register (saved)
    char *current_array_string;                       [SP,24]
    unsigned long int current_array_string_length;    [SP,32]
    unsigned long int current_index;                  [SP,40]
    unsigned long int format_string_length;           [SP,48]
    unsigned long int number_of_array_specs;          [SP,56]
    unsigned long int current_array_spec_num;         [SP,64]
    unsigned long int buffer_index;                   [SP,72]
    unsigned long int source_index;                   [SP,80]

    by saving the array and array length registers
    at the end of the stack frame, these then butt up
    against the other variadic arguments on the stack
    so we can use a single register to keep track on
    which pair of array and array length is being
    processed

    unsigned long int *array_one                      [SP,88]    X1
    unsigned long int array_one_length                [SP,96]    X2
    unsigned long int *array_two                      [SP,104]   X3
    unsigned long int array_two_length                [SP,112]   X4
    unsigned long int *array_three                    [SP,120]   X5
    unsigned long int array_three_length              [SP,128]   X6
    unsigned long int *array_four                     [SP,136]   X7

                                            
*/


pringle:
                  SUB SP, SP, 144         // make a stack frame to hold the registers
                  STR X0,  [SP,0]         // the table above shows what each saved register
                  STR X1,  [SP,88]        // means
                  STR X2,  [SP,96]
                  STR X3,  [SP,104]
                  STR X4,  [SP,112]
                  STR X5,  [SP,120]
                  STR X6,  [SP,128]
                  STR X7,  [SP,136]
                  STR X8,  [SP,8]
                  STR x30, [SP,16]

                  bl count_specs         // X0 already has the format string argument in it
                                         // for us to call count_specs so we know
                                         // how many array specs we are dealing with
                  STR X0, [SP,56]        // number_of_array_specs = count_specs(format_string)

                  MOV X0, 0              // 
                  STR X0, [SP,64]        // current_array_spec_num = 0
                  STR X0, [SP,72]        // buffer_index = 0
                  STR X0, [SP,40]        // current_index = 0
                  STR X0, [SP,80]        // source_index = 0

                  LDR X0, [SP,0]         // 
                  bl mystrlen            //
                  STR X0, [SP,48]        // format_string_length = mystrlen(format_string)

pringle_loop:     LDR X0,[SP,64]         // X0=current_array_spec_num
                  LDR X1,[SP,56]         // X1=number_of_array_specs
                  CMP X0,X1
                  beq done

                  // extern char* concat_array(unsigned long int*, unsigned long int);
                  ADD X2, SP, 88
                  LDR X3, [SP,64]        // X3 = current_array_spec_num
                  lsl X3, X3, 1          // always multiply this by two because there is an array and a length
                  LDR X0, [X2,X3,lsl#3]
                  ADD X3, X3, 1
                  LDR X1, [X2,X3,lsl#3]
                  bl concat_array
                  STR X0,  [SP,24]   // current_array_string = concat_array(array, length);
                  bl mystrlen        // current_array_string_length = mystrlen(current_array_string);
                  STR X0, [SP,32]    //
                  
                  //extern unsigned long int find_percent_a(char *STR, unsigned long int start_index);
                  LDR X0, [SP,0]
                  LDR X1, [SP,40]          // load current_index
                  bl find_percent_a
                  MOV X3, X0               // save new_index in X3

                  // mymemcpy(buffer+buffer_index,format_string+source_index,new_index-current_index)
                  adr X0, buffer
                  LDR X1, [SP,72]          // X1 = buffer_index
                  ADD X0, X0, X1           // X0 points at where to write
                  LDR X1, [SP,0]           // X1 = format_string
                  LDR X2, [SP,80]          // X2 = source_index
                  ADD X1, X1, X2           // X2 now points from where to read in the format string
                  LDR X4, [SP,40]          // X4 = current_index
                  SUB X2, X3, X4           // X2 now has the length to copy
                  bl mymemcpy
                  ADD X3, X3, 2
                  STR X3, [SP,40]          // update current index
                  LDR X1, [SP,72]          // 
                  ADD X1, X1, X2           //
                  STR X1, [SP,72]          // increment buffer_index by length written
                  LDR X1, [SP,80]          //
                  ADD X1, X1, X2           //
                  STR X1, [SP,80]          // increment source_index by length written

                  // now copy the array into the buffer
                  // mymemcpy(buffer+buffer_index,array_string,array_string_length)
                  adr X0, buffer
                  LDR X1, [SP,72]
                  ADD X0, X0, X1           // X0 now points where to write into
                  LDR X1, [SP,24]          // X1 now points at current_array_string
                  LDR X2, [SP,32]          // X2 = points at current_array_string_length
                  bl mymemcpy
                  LDR X1, [SP,72]          // 
                  ADD X1, X1, X2           //
                  STR X1, [SP,72]          // increment buffer_index by length written
                  LDR X1, [SP,80]          //
                  ADD X1, X1, 2            //
                  STR X1, [SP,80]          // increment source_index by the 2 characters of the format specifier
                  
                  LDR X0, [SP,64]
                  ADD X0, X0, 1
                  STR X0, [SP,64]          // increment current_array_spec_num
                  b pringle_loop

done:             LDR X0, [SP,56]
                  CMP X0, 0
                  beq just_load_original_format_string
                  // if source_index is not pointing to format_string_length
                  // then we need to copy the extra to the output buffer
                  // and increment buffer_index after the write
                  // by the residual as we will null terminate the output
                  // string next
                  LDR X0, [SP,80]
                  LDR X1, [SP,48]
                  beq null_terminate
                  adr X0, buffer
                  LDR X1, [SP,72]     // X1 = buffer_index
                  ADD X0, X0, X1      // X0 now points where to write
                  LDR X1, [SP,0]      // X1 = format string
                  LDR X2, [SP,80]     // X2 = source_index
                  ADD X1, X1, X2      // X1 now points where to read from in the format string
                  LDR X2, [SP,48]     // X2 now has format string length
                  LDR X3, [SP,80]     // X3 now has source_index
                  SUB X2, X2, X3      // X2 now has the size to mymemcpy
                  bl mymemcpy           // now start copying!!!!!
                  LDR X0, [SP,72]     // X0 now has buffer_index
                  ADD X0, X0, X2      // increment buffer_index by the size written
                  STR X0, [SP,72]     // write back the new buffer_index value

                  // need to null terminate the output string
null_terminate:   adr X0,buffer
                  LDR X1, [SP,72]    // X1 now has the buffer_index offset
                  MOV X2, 0
                  ADD X0, X0, X1
                  STRB w2, [X0]      // store the null in buffer + buffer_index
                  adr X0,buffer
                  bl myputs          // now output the string
                  b exit

just_load_original_format_string:
                  LDR X0, [SP,0]
                  bl myputs
exit:
                  LDR X1,  [SP,88]       // we restore the original
                  LDR X2,  [SP,96]       // registers we saved off on the stack at the beginning
                  LDR X3,  [SP,104]      // of the function with the exception
                  LDR X4,  [SP,112]      // of restoring X0, since that is being
                  LDR X5,  [SP,120]
                  LDR X6,  [SP,128]
                  LDR X7,  [SP,136]
                  LDR X8,  [SP,8]
                  LDR x30, [SP,16]       // used as the return value
                  ADD SP, SP, 144        // increment the stack pointer to
                  RET                    // pop our stack frame off the stack
                                         // and then return

/*
    Declare .data here if you need.
*/
.data
    buffer: .fill 8192, 1, 48