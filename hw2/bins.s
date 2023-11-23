/**
 * Name: Anna Hauk
 * Pledge: I pledge my honor that I have abided by the stevens honor system.
 */

.text
.global _start

// x0   arr pointer
// x1   length
// x2   left
// x3   right
// x4   mid
// x5   target
// x6   arr[mid]

_start:          adr x0, length       // check if length is zero, in which case
                 ldr x1, [x0]         // just jump out of the loop with not found
                 cmp x1,0
                 b.eq not_found

                 adr x0, target       // load target
                 ldr x5, [x0]
                 adr x0, arr          // point x0 at arr

                 mov x2,0             // left = 0
                 mov x3,x1            // right = length - 1
                 add x3,x3,-1

while:           cmp x2,x3            // while left <= right
                 b.gt not_found       // if we reach this condition, it means
                                      // the target was not found

                 sub x4, x3, x2       // mid = left + (right-left)//2
                 lsr x4, x4, 1        // notice the pemdas, divide (right-left)
                 add x4, x4, x2       // by two using right shift by 1 bit
                                      // then add left to the result

                 ldr x6, [x0, x4, lsl#3]   // x6 = arr[mid]

                 cmp x6, x5
                 b.eq found                // if arr[mid] == target
                 b.gt greater_than
                 add x2, x4, 1             // arr[mid] < target
                 b while                   // so left = mid + 1
greater_than:    add x3, x4, - 1           // arr[mid] > target
                 b while                   // so right = mid - 1

found:           adr x0, msg1              // have to find the length
                 mov x1, 0                 // of msg 1 first
                 b found_loop2             // so iterate through until
found_loop1:     add x1, x1, 1             // we find the null termination
found_loop2:     ldrb w2, [x0], 1          // byte.  when done, x1 will
                 cmp w2, 0                 // hold length
                 b.ne found_loop1

                 mov x0, 1                 // execute print()
                 mov x2, x1
                 adr x1, msg1
                 mov x8, 64
                 svc 0
                 b exit

not_found:       adr x0, msg2              // same story here
                 mov x1, 0                 // if we are going to
                 b not_found_loop2         // print not found msg
not_found_loop1: add x1, x1, 1             // have to find the length
not_found_loop2: ldrb w2, [x0], 1          // of msg2, so count bytes
                 cmp w2, 0                 // until the null termination
                 b.ne not_found_loop1      // byte

                 mov x0, 1                 // execute print()
                 mov x2, x1
                 adr x1, msg2
                 mov x8, 64
                 svc 0

exit:            mov x0, 0                 // exit the program
                 mov x8, 93
                 svc 0

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */
 