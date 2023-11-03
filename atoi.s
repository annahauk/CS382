/**
 * Name: Anna Hauk
 * Pledge: I pledge my honor that I have abided by the stevens honor system.
 */

.text
.global _start

_start:           adr x0, numstr
                  mov x1, 0            // x1 will be the length counter
                  b length_entry
count_increment:  add x1, x1, 1        // add to the count
length_entry:     ldrb w2, [x0], 1     // check if the character is zero
                  cmp  w2, 0           // at the end of the string
                  b.ne count_increment

                  // x1 has the length
                  adr x0, numstr       // point x0 at most signifigant digit
                  mov x2, 0            // zero out x2, it will be used to
                                       // accumulate the number
                  mov x3, 10           // x3 will be the by 10 multiplier
atoi_loop:        ldrb w4, [x0], 1
                  add w4,w4,-48        // decimals in ascii need to have
                                       // 48 subtracted to get the integer
                                       // value of the digit
                  madd w2, w2, w3, w4  // w2 will left shift by a digit
                                       // by multiplying by 10
                  add x1, x1, -1       // decrement from the length
                  cmp x1, 0            // and check for reaching zero
                  b.ne atoi_loop       // to know when to quit accumulating
                  adr x0, number       // store the computed number
                  str x2, [x0]         // in memory so that we can output
                                       // it in the print statement

/* Do not change any part of the following code */
exit:
    mov X0, 1
    adr x1, number
    mov x2, 8
    mov x8, 64
    svc 0
    mov x0, 0
    mov x8, 93
    svc 0

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */

