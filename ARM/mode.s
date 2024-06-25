.global _start

.bss 
arg1: .space 32         // space for 32 characters
output: .skip 12        // space for 12 bytes
buffer: .skip 1024      // space for 1024 bytes
numbers: .skip 1024     // space for storing numbers

.data
newline: .asciz "\n"    // new line

.text
_start:
    //argv[1] address
    ldr x0, [sp, 16]    // load address of argv[1]
    ldr x1, =arg1       // load address of arg1
    mov x2, 0           // initialize counter

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

open_file:
    // open file
    mov x0, -100        // open
    ldr x1, =arg1       // filename address
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

set_variables:
    ldr x1, =buffer     // buffer address
    ldr x10, =numbers   // numbers array address
    mov x3, 0           // number size = 0
    mov x4, 10          // base number
    mov x11, 0          // numbers array index

    // loop
loop:
    ldrb w2, [x1]       // load byte
    cmp w2, 36          // if $
    beq find_mode       // goto find_mode
    cmp w2, 10          // if \n
    beq store_number    // goto store_number
    cmp w2, 0           // if null terminator (end of buffer)
    beq find_mode       // goto find_mode
    sub w2, w2, 48      // convert to int
    uxtb x2, w2         // convert to 64 bit
    mul x3, x3, x4      // multiply by base
    add x3, x3, x2      // add digit
    add x1, x1, 1       // increment address
    b loop              // goto loop

store_number:
    add x15, x10, x11, LSL #3   // calculate address offset
    str x3, [x15]       // store number in array
    add x11, x11, 1     // increment array index
    mov x3, 0           // reset number
    add x1, x1, 1       // increment address
    b loop              // goto loop

find_mode:
    mov x12, 0          // mode frequency
    mov x13, 0          // mode value
    mov x14, 0          // outer loop index

outer_loop:
    cmp x14, x11
    bge print_mode

    add x15, x10, x14, LSL #3   // calculate address offset
    ldr x16, [x15]       // load number from array
    mov x17, 0          // inner loop index
    mov x18, 0          // current frequency

inner_loop:
    cmp x17, x11
    bge check_mode

    add x19, x10, x17, LSL #3   // calculate address offset
    ldr x20, [x19]       // load number from array
    cmp x16, x20
    bne skip_increment

    add x18, x18, 1     // increment current frequency

skip_increment:
    add x17, x17, 1     // increment inner loop index
    b inner_loop

check_mode:
    cmp x18, x12
    ble skip_update_mode

    mov x12, x18        // update mode frequency
    mov x13, x16        // update mode value

skip_update_mode:
    add x14, x14, 1     // increment outer loop index
    b outer_loop

print_mode:
    ldr x1, =output     // output address
    mov x2, x13         // mode value
    mov x3, 10          // base number
    mov x4, 0           // number size = 0

get_size:
    mov x5, x2          // copy of number
    mov x4, 0           // reset number size
get_digit_size:
    udiv x5, x5, x3     // divide number by base
    add x4, x4, 1       // increment size
    cmp x5, 0           // if number != 0
    bne get_digit_size  // continue if not zero

    add x1, x1, x4      // set string address offset
    mov w6, 10          // newline ascii
    strb w6, [x1]       // store newline
    sub x1, x1, 1       // decrement offset
    add x4, x4, 1       // increment string final size
    mov x5, x2          // copy of number
    mov x6, 0           // reset iterator

get_digit:
    udiv x7, x5, x3     // remove last digit
    msub x8, x7, x3, x5 // calculate last digit
    add x6, x6, 1       // increment iterator
    add w8, w8, 48      // convert to ASCII
    strb w8, [x1]       // store last digit
    sub x1, x1, 1       // decrement offset
    mov x5, x7          // update number
    cmp x5, 0           // if number != 0
    bne get_digit       // continue if not zero

print:
    mov x0, 1           // stdout
    ldr x1, =output     // load string address
    mov x2, x4          // string size
    mov x8, 64          // write syscall number
    svc 0               // syscall

end:
    mov x0, 0           // exit code
    mov x8, 93          // exit syscall number
    svc 0               // syscall
