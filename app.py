from flask import Flask, request, jsonify
from flask_cors import CORS
from Climate import Climate

new_climate = Climate()
new_climate.read_climate()

app = Flask(__name__)
CORS(app)

data = {
    'promedio': -1,
    'mediana': -1,
    'desviacion_estandar': -1,
    'maximo': -1,
    'minimo': -1,
    'moda': -1,
    'contador': -1
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