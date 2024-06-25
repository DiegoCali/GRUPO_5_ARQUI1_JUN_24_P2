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
        return int(str(result.stdout).replace('\x00', ''))
    
    def get_stnd_dev(self, variable):
        sqaverage = sp.run(['./ARM/sqaverage', f'ARM/DB/{variable}.txt'], text=True, capture_output=True).stdout
        average = sp.run(['./ARM/average', f'ARM/DB/{variable}.txt'], text=True, capture_output=True).stdout
        variance = int(sqaverage) - int(average)**2
        stnd_dev = sp.run(['./ARM/SquareRoot'], input=f'{str(variance)}\n', text=True, capture_output=True).stdout
        return stnd_dev 

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
    
    def get_air_quality(self):
        pass