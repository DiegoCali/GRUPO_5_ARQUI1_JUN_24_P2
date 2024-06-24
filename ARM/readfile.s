.global _start

.bss 
arg1: .space 32         // space for 32 caracters
output: .skip 12        // space for 12 bytes
buffer: .skip 1024      // space for 1024 bytes

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

    // print argv[1]
print_argv:
    mov x0, 1           // stdout
    mov x1, x1          // buffer address
    mov x2, 32          // 
    mov x8, 64          // write
    svc 0               // syscall

    mov x0, 1           // stdout
    ldr x1, =newline    // buffer address
    mov x2, 1           // buffer size
    mov x8, 64          // write
    svc 0               // syscall

open_file:
    // open file
    mov x0, -100        // open
    ldr x1, =arg1          // filename address
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

    // print file
    mov x0, 1           // stdout
    ldr x1, =buffer     // buffer address
    mov x2, 1024        // size address
    mov x8, 64          // write
    svc 0               // syscall

    // close file
    mov x0, x9          // file descriptor
    mov x8, 57          // close
    svc 0               // syscall


end:
    mov x0, 0           // exit code
    mov x8, 93          // exit syscall_num
    svc 0               // syscall
