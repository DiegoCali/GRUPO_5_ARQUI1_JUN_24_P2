import requests
from django.shortcuts import render
from django.http import JsonResponse
# Create your views here.


def home(request):
    return render(request, 'admin.html')

def obtener_datos(request):
    opcion = request.GET.get('option', '')  # Obtener el valor del parámetro 'option'
    
    
    if opcion == 'Temperatura':
        headers = ['Promedio', 'Mediana', 'Desviacion estandar', 'Maximo', 'Minimo', 'Moda', 'Contador']
        datos = {
            'headers': headers,
            'data': [
                {'promedio': 25, 'mediana': 3, 'desviacion_estandar': 52, 'maximo': 61, 'minimo': 25, 'moda': 320, 'contador': 25},
                
            ]
        }
    elif opcion == 'Humedad':
        headers = ['Encabezado1', 'Encabezado2', 'Encabezado3', 'Encabezado4', 'Encabezado5']
        datos = {
            'headers': headers,
            'data': [
                # Datos para Humedad
            ]
        }
    else:
        datos = {
            'headers': [],
            'data': []  # Si la opción no coincide con ninguna, devolver datos y encabezados vacíos
        }
    
    return JsonResponse(datos)