from Climate import Climate
from time import sleep

new_climate = Climate()

new_climate.read_climate()

while True:
    print(new_climate.get_climate_data())
    sleep(2)