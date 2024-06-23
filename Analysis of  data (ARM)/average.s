.global _start

.data
filename:
    .asciz "nums.txt"

.bss
buffer:
    .skip 1024

output:
    .skip 12

.text
_start:
    // open file
    mov x0, -100        // open
    ldr x1, =filename   // filename address
    mov x2, 0           // O_RDONLY 
    mov x8, 56          // openat
    svc #0              // syscall
    mov x9, x0          // store file descriptor

    // read file
    mov x0, x9          // file descriptor
    ldr x1, =buffer     // buffer address
    mov x2, 1024        // size address
    mov x8, 63          // read
    svc 0               // syscall

    // close file
    mov x0, x9          // file descriptor
    mov x8, 57          // close
    svc 0               // syscall

    ldr x1, =buffer     // buffer address
    mov x3, 0           // number size = 0
    mov x4, 10          // base number                

    // loop
loop:
    ldrb w2, [x1]       // load byte
    cmp w2, 36          // if $
    beq convert         // goto convert
    cmp w2, 10          // if \n
    beq skip_loop       // goto skip_loop
    sub w2, w2, 48      // convert to int
    uxtb x2, w2         // convert to 64 bit
    mul x3, x3, x4      // multiply by base
    add x3, x3, x2      // add digit
    add x1, x1, 1       // increment address
    b loop              // goto loop

    // skip loop
skip_loop:
    add x6, x6, 1       // increment counter
    add x1, x1, 1       // increment address
    add x5, x5, x3      // add to sum
    mov x3, 0           // reset number
    b loop              // goto loop

convert:
    udiv x5, x5, x6     // calculate average
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
