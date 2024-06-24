.global _start

.data
input:  .space 4            // Espacio para el número de entrada (3 dígitos + null terminator)
buffer: .space 32           // Espacio para la salida del número con formato

.text
_start:
    // Leer número de la entrada estándar (stdin)
    mov x0, 0                  // stdin (descriptor de archivo 0)
    ldr x1, =input             // buffer para almacenar el número leído
    mov x2, 4                  // leer hasta 4 bytes (3 dígitos + null terminator)
    mov x8, 63                 // syscall: read
    svc 0

    // Convertir el número ASCII a entero
    ldr x1, =input             // dirección del buffer de entrada
    mov w2, 0                  // inicializar el acumulador
convert_loop:
    ldrb w3, [x1], #1          // cargar el siguiente byte del buffer y avanzar
    cmp w3, 10                  // ¿es el byte null terminator?                         //esto lo cambie
    beq conversion_done        // si es null terminator, salir del bucle
    sub w3, w3, '0'            // convertir ASCII a entero
    mov w4, 10                 // multiplicador para convertir ASCII a entero
    mul w2, w2, w4             // multiplicar el acumulador por 10
    add w2, w2, w3             // sumar el nuevo dígito
    b convert_loop             // repetir el bucle
conversion_done:

    // Convertir el entero a flotante y calcular la raíz cuadrada
    scvtf s2, w2               // convertir entero a flotante
    fsqrt s0, s2               // calcular la raíz cuadrada
    fcvt d0, s0                // mover el resultado a un registro de punto flotante de doble precisión

    mov w3, 1000               // mover a una variable entera
    scvtf d3, w3               // convertir a flotante
    fmul d0, d0, d3            // multiplicar por 1000.0 para convertir a doble precisión
    fmul d0, d0, d3            // multiplicar por 1000.0 para convertir a doble precisión
    fcvtzu w1, d0             // convertir a entero y redondear

    //convertir numero entero a texto usando itoa
    mov w0, w1                 // número entero
    sxtw x0, w0
    ldr x1, =buffer            // dirección del buffer de salida
    bl itoa                   // convertir entero a cadena

    // Imprimir el resultado
    mov x0, 1                  // stdout (descriptor de archivo 1)
    ldr x1, =buffer            // dirección del buffer de salida
    mov x2, 32                 // longitud del mensaje (ajustar según sea necesario)
    mov x8, 64                 // syscall: write
    svc 0

    // Salir del programa
    mov x0, 0                  // código de salida
    mov x8, 93                 // syscall: exit
    svc 0

// Función itoa
itoa:
    // Guardar registros de retorno
    stp x29, x30, [sp, #-16]!  // Guardar x29 y x30 en la pila
    mov x29, sp                // Actualizar el puntero de marco de pila

    // Inicialización
    mov x2, #10         // base = 10
    mov x3, x1          // Puntero de inicio del buffer
    mov x4, x0          // Número original
    mov x6, 0          // contador de digitos

itoa_loop:
    add x6, x6, 1       // Incrementar contador de dígitos
    cmp x6, #7        // Comparar num con '.'
    beq set_point       // si el contador llego a 6, establecer el punto decimal

    udiv x0, x4, x2     // x0 = num / base
    msub x5, x0, x2, x4 // x5 = num % base

    add x5, x5, #'0'    // Convertir dígito a carácter
    strb w5, [x3]       // Escribir carácter en buffer
    add x3, x3, #1      // Avanzar el buffer

    mov x4, x0          // num = x0
    cbnz x4, itoa_loop  // Repetir si num != 0

    // Termina la cadena
    mov w5, #0
    strb w5, [x3]       // Terminar cadena con '\0'

    // Invertir la cadena en buffer
    sub x3, x3, #1
    mov x4, x1          // Puntero al inicio del buffer
    mov x5, x3          // Puntero al final del buffer
itoa_reverse:
    ldrb w6, [x4]       // Leer carácter del inicio
    ldrb w7, [x5]       // Leer carácter del final
    strb w7, [x4]       // Escribir carácter del final al inicio
    strb w6, [x5]       // Escribir carácter del inicio al final
    add x4, x4, #1      // Avanzar hacia adelante
    sub x5, x5, #1      // Retroceder hacia atrás
    cmp x4, x5          // Comparar punteros
    blo itoa_reverse    // Repetir si no se cruzan

    // Restaurar registros de retorno
    ldp x29, x30, [sp], #16 // Restaurar x29 y x30 desde la pila
    ret                 // Retornar de la función
set_point:
    mov x5, #'.'    // Convertir dígito a carácter
    strb w5, [x3]       // Escribir carácter en buffer
    add x3, x3, #1      // Avanzar el buffer
    mov x4, x0          // num = x0
    cbnz x4, itoa_loop  // Repetir si num != 0
    ret
