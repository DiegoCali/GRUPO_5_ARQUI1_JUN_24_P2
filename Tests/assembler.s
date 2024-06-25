.global _start

.bss
input:
    .space 3

.text
_start:
    mov x0, 0
    ldr x1, =input
    mov x2, 2
    mov x8, 63
    svc 0

    ldr x0, =input
    ldrb w1, [x0]
    sub w1, w1, 48
    ldrb w2, [x0, 1]
    sub w2, w2, 48
    add w3, w1, w2 

    uxtb x0, w3
    mov x8, 93
    svc 0
