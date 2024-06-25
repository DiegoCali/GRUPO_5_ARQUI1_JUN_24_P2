from flask import Flask, request, jsonify
from flask_cors import CORS
from Climate import Climate
from ARM.Calculator import Calculator

# Climate reader
new_climate = Climate()
new_climate.read_climate()

# Data calculator
calc = Calculator()

app = Flask(__name__)
CORS(app)

@app.route('/Temperatura')
def get_temp():
    return jsonify(calc.get_data('temp'))

@app.route('/Humedad')
def get_hum():
    return jsonify(calc.get_data('humidity'))

@app.route('/VelocidadViento')
def get_vel():
    return jsonify(calc.get_data('wind'))

@app.route('/PresionBarometrica')
def get_press():
    return jsonify(calc.get_data('pressure'))

@app.route('/CalidadAire')
def get_air():
    return jsonify({'contador_bueno': 90, 'contador_malo': 10})

if __name__ == '__main__':
    app.run()