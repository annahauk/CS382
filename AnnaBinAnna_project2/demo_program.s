// Anna Hauk
// I pledge my honor that I have abided by the Stevens Honor System
// This program loads immediate values of 10
// into and 9 into register R1 and R0 respectively.
// It then subtracts register 0 from register 1 and
// stores the result in register 2.  It then writes
// register 2 to address 48 (0x30) in the RAM.
// Then, it loads that same address location into register 0.
// It then loads register 2 with the value 2 and stores that
// value at location 49 (0x31).  It then loads location 0x31
// in RAM to register 1.  Then it adds register 0 and register
// 1 together, i.e. 1+2 and stores the result, 3, in register R3.
// Finally it writes that value in register 3 (the 3) to the last
// location in RAM at location (0xFF).


.text

LDR R0,#09    //  0409
LDR R1,#0x0A  //  050A
SUB R2,R1,R0  //  1520
STR R2,0x30   //  0E30
LDR R0,0x30   //  0830
LDR R2,#2     //  0602
STR R2,0x31   //  0E31
LDR R1,0x31   //  0931
ADD R3,R0,R1  //  1070
STR R3,0xFF   //  0FFF

.data

// here are the directive possibilities
// .byte     allocate one-byte  block of memory, and specify the initial contents
// .hword    allocate two-byte  block of memory, and specify the initial contents
// .word     allocate four-byte block of memory, and specify the initial contents
// .skip     n allocate n bytes of uninitialized storage, just a label placeholder
// .string "the string" allocates ascii bytes with a null terminating byte

single_byte: .byte 0xaa
two_bytes:   .hword 0xbeef
four_bytes:  .word 0xfeedf00d
scratchpad:  .skip 1
a_string:    .string "38\"2392"
another_two: .hword 0xaabb
more_scratch: .skip 30
ping:        .byte 0xff
pong:        .byte 0xee
 