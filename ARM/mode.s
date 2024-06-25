.global _start

.data
filename:
    .asciz "DB/temp.txt"

.bss
buffer:
    .skip 1024

numbers:
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
    udiv x5, x2, x3     // remove last digit
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
    add w8, w8, 48      // convert to ASCII
    strb w8, [x1]       // store last digit
    sub x1, x1, 1       // decrement offset
    mov x5, x7          // number remain
    cmp x5, 0           // if number != 0
    bne get_digit       // goto get_digit

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
