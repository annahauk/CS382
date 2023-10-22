.text
.global _start
.extern printf
//printf returns the number of characters that you're printing


/* char _uppercase(char lower) 
    returns a char (1 byte)
*/
_uppercase:
    SUB SP, SP, 16      //allocates stack space
    STR X30, [SP]       //store the return address into SP
    SUB W0, W0, 32      //Subtracts 32 from the ASCII value of the char to get uppercase
    LDR X30, [SP]       //loads value of SP into X30
    ADD SP, SP, 16      //adds 16 to stack pointer
    RET                 //returns the value in W0; the uppercase letter

/* int _toupper(char* string) */
_toupper: //Sdiv move value into register to use SDIV
//things in X0-7 get "deleted"
    //SETUP
    SUB SP, SP, 32       //Allocates space on the stack for the return address; updates stack pointer
    STR X30, [SP]       //Stores the return address into the stack
    STR X19, [SP, 8]    //Stores the callee register into the stack; string
    STR X20, [SP, 16]   //Stores the callee register into stack; counter

    MOV X19, X0         //puts address of string into X19
    MOV X20, 0           //X2 will hold the length of the string and will update as we iterate
    //need to loop through the array while also getting the value of the length of the string

    L1: LDRB W0, [X19, X20]   //puts letter 'h' into W0
    CBZ W0, end         //Checks if the string is terminated

    BL _uppercase       //Calls _uppercase() to get the letter to uppercase
    STRB W0, [X19, X20] //stores the new uppercase letter back into the original string (str)
                        //uses counter as offset to replace correct letters

    ADD X20, X20, 1       //Adds one to for the length of the string that we're keeping track of in X2
   
    B L1                // loop call to access the other characters in the string till it's all uppercase

    end:
    MOV X2, X19         //moves the new str into register X2
    MOV X1, X20         //moves length of string into X1
    //ENDING
    LDR X30, [SP]       //Stores the return address into the stack
    LDR X19, [SP, 8]    //Stores the callee register into the stack; string
    LDR X20, [SP, 16]   //Stores the callee register into stack; counter

    ADD SP, SP, 32       // Return space on the stack from char; update stack pointer
    RET                 //returns the value in X0/W0; the uppercase string

_start:

    ADR X0, str         // Load address of string to be modified
    BL _toupper         // calls _toupper
    ADR X0, outstr      // Load address of the return string for use in other func
    
    //X0 has the address of outstr
    //X1 has the length of the string
    //X2 has the str 

    BL printf

    MOV  X0, 0
    MOV  X8, 93
    SVC  0


.data
str:    .string   "helloworld"
outstr: .string   "Converted %ld characters: %s\n"


//aarch64-linux-gnu-as lab5_starter.s -o lab5_starter.o   
//aarch64-linux-gnu-ld lab5_starter.o -lc
//qemu-aarch64 -L /usr/aarch64-linux-gnu/ a.out
