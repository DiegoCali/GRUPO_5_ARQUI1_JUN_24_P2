.global _start

.bss 
arg1: .space 32         // space for 32 caracters
output: .skip 12        // space for 12 bytes

.data
newline: .asciz "\n"    // new line

.text
_start:
    //argv[1] address
    ldr x0, [sp, 16]    // load address of argv[1]
    ldr x1, =arg1       // load address of arg1
    mov x2, 0           //

    // copy argv[1] to arg1
loop_argv:
    ldrb w3, [x0, x2]   // load byte
    cmp w3, 0           // if null
    beq end_loop_argv   // goto end_loop_argv
    strb w3, [x1, x2]   // store byte
    add x2, x2, 1       // increment counter
    b loop_argv         // goto loop_argv

    // add eof
end_loop_argv:
    mov w0, 0           // add eof
    strb w0, [x1, x2]   // store byte

set_variables:
    ldr x1, =arg1        // buffer address
    mov x3, 0           // number size = 0
    mov x4, 10          // base number 
    mov x5, 0           // num1
    mov x6, 0           // num2 
    mov x7, 0           // counter              

    //casting number
loop:
    ldrb w2, [x1]       // load byte
    cmp w2, 36          // if $
    beq convert         // goto convert
    cmp w2, 42          // if *
    beq skip_loop       // goto skip_loop
    sub w2, w2, 48      // convert to int
    uxtb x2, w2         // convert to 64 bit
    mul x3, x3, x4      // multiply by base
    add x3, x3, x2      // add digit
    add x1, x1, 1       // increment address
    b loop              // goto loop

    // skip loop
skip_loop:
    add x7, x7, 1       // increment counter
    cmp X7, 1
    beq first_num
    b loop              // goto loop

first_num:
    add x1, x1, 1       // increment address
    mov x5, x3
    mov x3, 0           // reset number
    b loop              // goto loop

convert:
    // second num
    add x1, x1, 1       // increment address
    mov x6, x3          // second num
    mov x3, 0           // reset number
    // variance
    mul x6, x6, x6      // second squared
    sub x5, x5, x6      // subtract
    ldr x1, =output     // output address
    mov x2, x5          // number to convert
    mov x3, 10          // base number
    mov x4, 0           // number size = 0

get_size:
    udiv x5, x5, x3     // remove last digit
    add x4, x4, 1       // increment size
    cmp x5, 0           // if number != 0
    bne get_size        // goto get_size

    add x1, x1, x4      // str addr offset
    mov w6, 10          // newline ascii
    strb w6, [x1]       // store newline
    sub x1, x1, 1       // decrement offset
    add x4, x4, 1       // str final size
    mov x5, x2          // copy of number
    mov x6, 0           // iter number = 0

get_digit:
    udiv x7, x5, x3     // remove last digit
    msub x8, x7, x3, x5 // last digit
    add x6, x6, 1       // increment iter
    strb w8, [x1]       // store last digit
    sub x1, x1, 1       // decrement offset
    mov x5, x7          // number remain
    cmp x5, 0           // if number != 0
    bne get_digit       // goto get_digit

    add x1, x1, 1       // reset addr

setascii:
    ldrb w9, [x1]       // load left digit
    add w9, w9, 48      // set ascii
    strb w9, [x1]       // store ascii
    add x1, x1, 1       // increment addr
    sub x6, x6, 1       // decrement iter
    cmp x6, 0           // if iter != 0
    bne setascii        // goto setascii

print:
    mov x0, 1           // stdout
    ldr x1, =output     // load str
    mov x2, x4          // str size
    mov x8, 64          // write syscall_num
    svc 0               // syscall

end:
    mov x0, 0           // exit code
    mov x8, 93          // exit syscall_num
    svc 0               // syscall
