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
    mov x0, -100
    ldr x1, =filename
    mov x2, 0
    mov x8, 56
    svc 0

    mov x9, x0

    mov x0, x9
    ldr x1, =buffer
    mov x2, 1024
    mov x8, 63
    svc 0

    ldr x1, =buffer
    mov x3, 0
    mov x4, 10
    mov x5, 0
    mov x6, 0

loop:
    ldrb w2, [x1]
    cmp w2, 36
    beq convert
    cmp w2, 10
    beq skip_loop
    sub w2, w2, 48
    uxtb x2, w2
    mul x3, x3, x4
    add x3, x3, x2
    add x1, x1, 1
    b loop

skip_loop:
    add x6, x6, 1
    add x1, x1, 1
    add x5, x5, x3
    mov x3, 0
    b loop

convert:
    udiv x5, x5, x6
    ldr x1, =output
    mov x2, x5
    mov x3, 10
    mov x4, 1

get_size:
    udiv x2, x2, x3
    add x2, x2, 48
    cmp x2, 57
    mul x4, x4, x3
    ble get_digit
    sub x2, x2, 48
    b get_size

get_digit:
    mov w2, w2
    strb w2, [x1]
    sub w2, w2, 48
    uxtb x2, w2
    mul x2, x2, x4
    sub x5, x5, x2
    cmp x5, 10
    blt save_str
    mov x2, x5
    add x1, x1, 1
    mov x4, 1
    b get_size

save_str:
    add x1, x1, 1
    mov w5, w5
    add w5, w5, 48
    strb w5, [x1]
    add x1, x1, 1
    mov w5, 10
    strb w5, [x1]

print_str:
    mov x0, 1
    ldr x1, =output
    mov x2, 12
    mov x8, 64
    svc 0

end:
    mov x0, 0
    mov x8, 93
    svc 0
