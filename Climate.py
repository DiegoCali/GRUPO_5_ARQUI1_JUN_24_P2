import RPi.GPIO as GPIO
import adafruit_dht
import board
import threading
from time import sleep
from bmp280 import BMP280
try:
    from smbus2 import SMBus
except ImportError:
    from smbus import SMBus

GPIO.setwarnings(False)

encoder = 0x40
wind = 0x41
pcf8581 = 0x48
bmp_280 = 0x76
light = 4

GPIO.setup(light, GPIO.IN)

class Climate:
    def __init__(self):
        self.bus = SMBus(1)
        self.bmp_280 = BMP280(i2c_dev=self.bus, i2c_addr=bmp_280)
        self.dht_11 = adafruit_dht.DHT11(board.D27)
        self.temperature = 0   # In celsius
        self.humidity = 0      # In percentage
        self.daylight = True   # Boolean
        self.pressure = 0      # In pascals
        self.air_condition = 0 # Value 0-255 -> Convert to Percentage
        self.air_velocity  = 0 # Value 0-255 -> Convert to RPM
    
    def get_climate_data(self):
        data = {
            'temperature': self.temperature,
            'humidity': self.humidity,
            'daylight': self.daylight,
            'pressure': self.pressure,
            'air_condition': self.air_condition,
            'air_velocity': self.air_velocity
        }
        return data
    
    def read_sensor(self):
        while True:
            try:
                self.temperature = round(self.dht_11.temperature)
                self.humidity = round(self.dht_11.humidity)
            except:
                self.temperature = self.temperature
                self.humidity = self.humidity
            if GPIO.input(light):
                self.daylight = False
            else:
                self.daylight = True
            try:
                self.pressure = round(self.bmp_280.get_pressure())
            except:
                self.pressure = self.pressure
            try:
                self.bus.write_byte(pcf8581, wind)
                self.air_condition = self.bus.read_byte(pcf8581)
            except:
                self.air_condition = self.air_condition
            try:
                self.bus.write_byte(pcf8581, encoder)
                self.air_velocity = self.bus.read_byte(pcf8581)
            except:
                self.air_velocity = self.air_velocity
            sleep(10)

    def read_climate(self):
        th1 = threading.Thread(target=self.read_sensor, args=())
        th1.start()