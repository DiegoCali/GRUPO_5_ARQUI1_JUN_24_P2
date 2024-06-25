import requests
from django.shortcuts import render
from django.http import JsonResponse
# Create your views here.


def home(request):
    return render(request, 'admin.html')

def obtener_datos(request):
    opcion = request.GET.get('option', '')  # Obtener el valor del parámetro 'option'
    
    response = requests.get(f'http://127.0.0.1:5000/{opcion}').json()

    if opcion == 'CalidadAire':
        headers = ['Contador_bueno', 'Contador_Malo']
        datos = {
            'headers': headers,
            'data': [
                response,
            ]
        }
    else:
        headers = ['Promedio', 'Mediana', 'Desviacion_Estandar', 'Maximo', 'Minimo', 'Moda', 'Contador']
        datos = {
            'headers': headers,
            'data': [
                response,
            ] 
        }
    
    return JsonResponse(datos)

def obtener_datosGrafica(request):
    response = requests.get('http://127.0.0.1:5000/CalidadAire')
    print(response.json())
    return JsonResponse(response.json())