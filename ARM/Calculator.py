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
        pass

    def get_average(self, variable):
        result = sp.run([f'./average DB/{variable}.txt'], text=True, capture_output=True)
        return result.stdout
    
    def get_median(self, variable):
        result = sp.run([f'./median DB/{variable}.txt'], text=True, capture_output=True)
        return result.stdout
    
    def get_stnd_dev(self, variable):
        sqaverage = sp.run([f'./sqaverage DB/{variable}.txt'], text=True, capture_output=True).stdout
        average = sp.run([f'./sqaverage DB/{variable}.txt'], text=True, capture_output=True).stdout
        variance = int(sqaverage) - int(average*average)
        stnd_dev = sp.run([f'./SquareRoot DB/{str(variance)}.txt'], text=True, capture_output=True).stdout
        return stnd_dev

    def get_max(self, variable):
        result = sp.run([f'./max DB/{variable}.txt'], text=True, capture_output=True)
        return result.stdout

    def get_min(self, variable):
        result = sp.run([f'./mini DB/{variable}.txt'], text=True, capture_output=True)
        return result.stdout

    def get_mode(self, variable):
        result = sp.run([f'./mode DB/{variable}.txt'], text=True, capture_output=True)
        return result.stdout

    def get_counter(self, variable):
        result = sp.run([f'./counter DB/{variable}.txt'], text=True, capture_output=True)
        return result.stdout