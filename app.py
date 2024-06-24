from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

data ={
    'promedio': 25,
    'mediana': 3,
    'desviacion_estandar': 52,
    'maximo': 61,
    'minimo': 25,
    'moda': 320,
    'contador': 25
}

@app.route('/Temperatura')
def get_temp():
    print(data)
    return jsonify(data)

@app.route('/Humedad')
def get_hum():
    return jsonify(data)

@app.route('/VelocidadViento')
def get_vel():
    return jsonify(data)

@app.route('/PresionBarometrica')
def get_press():
    return jsonify(data)

@app.route('/CalidadAire')
def get_air():
    return jsonify({'contador_bueno': 90, 'contador_malo': 10})

if __name__ == '__main__':
    app.run()