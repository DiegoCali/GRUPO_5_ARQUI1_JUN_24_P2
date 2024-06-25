.global _start

.bss 
arg1: .space 32         // space for 32 caracters
output: .skip 12        // space for 12 bytes
//buffer: .space 1024 // space for 1024 bytes

.data
buffer: .asciz "1\n2\n3\n4\n5\n6\n7\n8\n9\n$" // space for 1024 bytes

.text
_start:
    
    ldr x1, =buffer     // buffer address
    mov x2, 0           // O_RDONLY
    mov x9, 0           // counter loop

count_loop:
    // Contar la cantidad de numeros
    ldrb w3, [x1, x2]          // cargar el siguiente byte del buffer y avanzar
    add x2, x2, 1              // avanzar al siguiente byte
    cmp w3, #10                // comparar si es un salto de linea
    csinc x9, x9, x9, ne       // si es un salto de linea es correcto incrementa en 1 al x9, de no ser asi no incrementa
    cmp w3, #36                // comparar si es el final del buffer
    bne count_loop            // si no es el final del buffer regresa a count_loop

    //x9 contiene ahora la cantidad de numeros que hay cargados
    mov x2, x9                 // cantidad de numeros
    mov x0, x9                 // cantidad de numeros
    and x0, x0, 1              // verificar si es impar
    //el retorno de and es 1 si es impar y 0 si es par, recordar que Z solo se activa si el resultado es 0
    //beq even_number           // si es par
    cbz x0, even_number      // Si el bit menos significativo es 0, es par.

odd_number:
    // sacamos la mediana para cantidad par de numeros
    mov x3, 2                  // dividir entre 2 (posicion del numero buscado)
    udiv x0, x2, x3             // dividir entre 2 (posicion del numero buscado)
    //------------------variables de entrada-------------------
    //x0 contiene la posicion del numero buscado
    //x1 contiene la direccion del buffer
    mov x2, 0                  // posicion de caracter
    mov x3, 0                  // lector de caracter
    mov x9, 1                  // contador de numeros
    bl search_position          // buscar la posicion del numero

    //------------------variables de entrada-------------------
    //x0 no es relevante pero retornara el valor buscado
    //x1 contiene la direccion del buffer
    mov x2, 0                  // temporal
    mov x3, 0                  // lector de caracter
    mov x4, 0                    // variable temporal
    mov x5, x0                   // posicion del numero  
    //ldrb w0, [x1, x2]          // cargar el siguiente byte del buffer y avanzar
    bl concat_number             // concatenar el numero
    mov x6, x0                   // guardar el numero 1 en x6

    //imprimir el numero
    ldr x1, =output            // dirección del buffer de salida
    bl itoa                   // convertir entero a cadena

    // Imprimir el resultado
    mov x0, 1                  // stdout (descriptor de archivo 1)
    ldr x1, =output            // dirección del buffer de salida
    mov x2, 32                 // longitud del mensaje (ajustar según sea necesario)
    mov x8, 64                 // syscall: write
    svc 0
    b _end


even_number:
    // sacamos la mediana para cantidad par de numeros
    mov x3, 2                  // dividir entre 2 (posicion del numero buscado)
    udiv x0, x2, x3             // dividir entre 2 (posicion del numero buscado)
    //------------------variables de entrada-------------------
    //x0 contiene la posicion del numero buscado
    //x1 contiene la direccion del buffer
    mov x2, 0                  // posicion de caracter
    mov x3, 0                  // lector de caracter
    mov x9, 1                  // contador de numeros
    bl search_position          // buscar la posicion del numero

    //------------------variables de entrada-------------------
    //x0 no es relevante pero retornara el valor buscado
    //x1 contiene la direccion del buffer
    mov x2, 0                  // temporal
    mov x3, 0                  // lector de caracter
    mov x4, 0                    // variable temporal
    mov x5, x0                   // posicion del numero  
    //ldrb w0, [x1, x2]          // cargar el siguiente byte del buffer y avanzar
    bl concat_number             // concatenar el numero
    mov x6, x0                   // guardar el numero 1 en x6

    //------------------variables de entrada-------------------
    //x0 no es relevante pero retornara el valor buscado
    //x1 contiene la direccion del buffer
    mov x2, 0                  // temporal
    mov x3, 0                  // lector de caracter
    mov x4, 0                    // variable temporal
    //x5 contiene la posicion del numero siguiente al numero 1 (numero 2)
    bl concat_number             // concatenar el numero

    add x0, x0, x6
    mov x1, 2

    // Convertir el entero a flotante y calcular la raíz cuadrada
    scvtf s0, w0               // convertir entero a flotante
    scvtf s1, x1               // convertir entero a flotante
    fdiv s0, s0, s1            // dividir el primer numero entre el segundo
    fcvt d0, s0                // mover el resultado a un registro de punto flotante de doble precisión

    mov w3, 1000               // mover a una variable entera
    scvtf d3, w3               // convertir a flotante
    fmul d0, d0, d3            // multiplicar por 1000.0 para convertir a doble precisión
    fmul d0, d0, d3            // multiplicar por 1000.0 para convertir a doble precisión
    fcvtzu w1, d0             // convertir a entero y redondear

    //convertir numero entero a texto usando itoa
    mov w0, w1                 // número entero
    sxtw x0, w0
    ldr x1, =output            // dirección del buffer de salida
    bl itoa                   // convertir entero a cadena

    // Imprimir el resultado
    mov x0, 1                  // stdout (descriptor de archivo 1)
    ldr x1, =output            // dirección del buffer de salida
    mov x2, 32                 // longitud del mensaje (ajustar según sea necesario)
    mov x8, 64                 // syscall: write
    svc 0
    b _end



search_position: //(x1=buffer, x2=posicion[se altera], x3=0)
    ldrb w3, [x1, x2]          // cargar el siguiente byte del buffer y avanzar
    add x2, x2, 1              // avanzar al siguiente byte
    cmp w3, #10                // comparar si es un salto de linea
    csinc x9, x9, x9, ne       // si es un salto de linea es correcto incrementa en 1 al x9, de no ser asi no incrementa
    cmp x9, x0                 // comparar si la posicion ya fue encontrada
    bne search_position        // si no es el final del buffer regresa a count_loop
    mov x0, x2                 // regresa la posicion del numero
    ret

concat_number: //(x1=buffer, x2=posicion[se altera], x3=0)
    ldrb w3, [x1, x5]          // cargar el siguiente byte del buffer y avanzar
    add x5, x5, 1              // avanzar al siguiente byte
    sub w3, w3, #'0'    // Convertir carácter a dígito
    cmp w3, #9          // Comparar si el dígito está en el rango 0-9
    bhs concat_number_end        // Si no está en el rango, terminar
    mov x4, #10
    mul x2, x2, x4      // resultado *= 10
    add x2, x2, x3      // resultado += dígito
    b concat_number         // Repetir el ciclo

concat_number_end:
    mov x0, x2          // Poner el resultado en x0
    ret                 // Retornar de la función
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




_end:
    // Salir del programa
    mov x8, 93                 // syscall: exit
    svc 0
