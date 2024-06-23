import subprocess

def sum_asm(num1, num2):
    result = subprocess.run(['./assembler'], input=f'{num1}{num2}\n', text=True, capture_output=True)
    return result.returncode

array = [1, 2, 3, 4]
print('Suma de numeros en asembler de:', array)
total = 0
for num in array:
    total = sum_asm(total, num)
print(f'La suma es: {total}')

def Desviacion_estandar(num): #el num solamente puede ser un entero y como maximo de 3 digitos
    result = subprocess.run(['../Analysis of  data (ARM)/SquareRoot'], input=f'{num}\n', text=True, capture_output=True)
    return float(result.stdout)