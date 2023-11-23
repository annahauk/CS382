/**
 * Name: Anna Hauk
 * Pledge: I pledge my honor that I have abided by the stevens honor system.
*/

.text
.global _start

_start:       adr x0, src_str     // point x0 at src_str
              adr x1, dst_str     // point x1 at dst_str
              mov x3, 0           // x3 will be a length counter, init to zero
              b copy
loop:         add x3, x3, 1       // increment length
copy:         ldrb w2, [x0], 1    // store a byte from src to dest
              strb w2, [x1], 1
              cmp  w2, 0          // check if source is at the zero termination
              b.ne loop           // if not, keep copying from src to dst

              mov  x0, 1          // set output to stdout
              adr  x1, dst_str    // print source location is dst_str
              cmp  X3, 0          // if length is zero, test program
              b.ne length         // is still expecting some output
              mov x2, 1           // so init print length to 1
              b finish_print      // so it can output the null/zero
length:       mov  x2, x3         // otherwise set print length to string length
finish_print: mov  x8, 64         // set command to print
              svc 0               // and execute the print command
              mov x0, 0           // set program return value to 0
              mov X8, 93          // set command to exit program
              svc 0               // and exit

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */
 