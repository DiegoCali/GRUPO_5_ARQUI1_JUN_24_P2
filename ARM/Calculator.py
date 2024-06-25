import subprocess as sp

class Calculator:

    def __init__(self):
        self.data = {
            'promedio': -1,
            'mediana': -1,
            'desviacion_estandar': -1,
            'maximo': -1,
            'minimo': -1,
            'moda': -1,
            'contador': -1
        }

    def get_data(self, variable):
        self.data = {
            'promedio': self.get_average(variable),
            'mediana': self.get_median(variable),
            'desviacion_estandar': self.get_stnd_dev(variable),
            'maximo': self.get_max(variable),
            'minimo': self.get_min(variable),
            'moda': self.get_mode(variable),
            'contador': self.get_counter(variable)
        }
        return self.data
    
    def get_air(self):
        air_data = {
            'contador_bueno': self.good_air(),
            'contador_malo': self.bad_air()
        }
        return air_data

    def good_air(self):
        result = sp.run(['./ARM/High-quality', 'ARM/DB/air.txt'], text=True, capture_output=True)
        return int(result.stdout)

    def bad_air(self):
        result = sp.run(['./ARM/Low-quality', 'ARM/DB/air.txt'], text=True, capture_output=True)
        return int(result.stdout)

    def get_average(self, variable):
        result = sp.run(['./ARM/average', f'ARM/DB/{variable}.txt'], text=True, capture_output=True)
        return int(result.stdout)
    
    def get_median(self, variable):
        f = open(f'ARM/DB/{variable}.txt', 'r')
        string = f.read()
        f.close()
        array = string.split()
        array.pop()
        array.sort()
        array.append('$')
        f = open('ARM/DB/sorted.txt', 'w')
        for data in array:
            f.write(str(data) + '\n')
        f.close()
        result = sp.run(['./ARM/median'], text=True, capture_output=True)
        return round(float(str(result.stdout).replace('\x00', '')), 2)
    
    def get_stnd_dev(self, variable):
        sqaverage = sp.run(['./ARM/sqaverage', f'ARM/DB/{variable}.txt'], text=True, capture_output=True).stdout
        average = sp.run(['./ARM/average', f'ARM/DB/{variable}.txt'], text=True, capture_output=True).stdout
        sqaverage = int(sqaverage)
        average = int(average)
        variance = sp.run(['./ARM/variance', f'{sqaverage}*{average}$'], text=True, capture_output=True).stdout
        variance = int(variance)
        stnd_dev = sp.run(['./ARM/SquareRoot'], input=f'{variance}\n', text=True, capture_output=True).stdout
        return round(float(str(stnd_dev).replace('\x00', '')), 2)

    def get_max(self, variable):
        result = sp.run(['./ARM/max', f'ARM/DB/{variable}.txt'], text=True, capture_output=True)
        return int(result.stdout)

    def get_min(self, variable):
        result = sp.run(['./ARM/mini', f'ARM/DB/{variable}.txt'], text=True, capture_output=True)
        return int(result.stdout)

    def get_mode(self, variable):
        result = sp.run(['./ARM/mode', f'ARM/DB/{variable}.txt'], text=True, capture_output=True)
        return int(result.stdout)

    def get_counter(self, variable):
        result = sp.run(['./ARM/counter', f'ARM/DB/{variable}.txt'], text=True, capture_output=True)
        return int(result.stdout)