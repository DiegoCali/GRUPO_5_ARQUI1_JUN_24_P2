import subprocess
from Climate import Climate
from time import sleep

new_climate = Climate()

new_climate.read_climate()

num = 2

while True:
    result = subprocess.run('./ARM/SquareRoot', input=f'{num}\n', text=True, capture_output=True)
    print(result.stdout)
    print(new_climate.get_climate_data())
    num = num * 2
    sleep(2)