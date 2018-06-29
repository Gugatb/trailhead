
import re
import urllib.request

from datetime import datetime
# from flask import Flask, request
# from flask_restful import Resource, Api, reqparse
# from flask import jsonify
from mongodb import *

# app = Flask(__name__)
# api = Api(app)
db = MongoDB()

# Tempo de vida da cache (5 minutos).
time_life = 20 #5 * 60

def get_information(profile_id):
    '''
    Obter a informacao.
    Author: Gugatb
    Date: 29/06/2018
    Param: profile_id o id do perfil
    Return: information a informacao
    '''
    information = {
        'profile_id': '',
        'name': '',
        'badges': 0,
        'trails': 0,
        'points': 0,
        'time': str(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    }

    try:
        # Ler a cache.
        json = db.readCache('cache', profile_id, time_life)

        if json is None:
            html = urllib.request.urlopen('https://trailhead.salesforce.com/pt-BR/me/' + profile_id).read()
            string = str(html)

            if html is not None and len(string) > 0:
                # Definir o id.
                information['profile_id'] = profile_id

                # Obter o nome.
                matches = re.search('<h1 [^>]*data-test-user-name[^>]*>([^<>]*)<\/h1>', string)
                information['name'] = matches.group(1) if matches is not None else ''

                # Obter os emblemas.
                matches = re.search('<div [^>]*data-test-badges-count[^>]*>([^<>]*)<\/div>', string)
                information['badges'] = int(matches.group(1)) if matches is not None else 0

                # Obter os trilhas.
                matches = re.search('<div [^>]*data-test-trails-count[^>]*>\n([^<>]*)\n<\/div>', string)
                information['trails'] = int(matches.group(1)) if matches is not None else 0

                # Obter os pontos.
                matches = re.search('<div [^>]*data-test-points-count[^>]*>\n([^<>]*)\n<\/div>', string)
                information['points'] = int(matches.group(1)) if matches is not None else 0

                # Inserir o documento na cache.
                db.insert('cache', information)
            else:
                information = {
                    'profile_id': json['profile_id'],
                    'name': json['name'],
                    'badges': json['badges'],
                    'trails': json['trails'],
                    'points': json['points'],
                    'time': json['time']
                }

    except Exception as message:
        print(str(message))
    return information

def get_informations(profile_ids):
    '''
    Obter a informacao.
    Author: Gugatb
    Date: 29/06/2018
    Param: profile_ids os ids de perfis
    Return: informations as informacoes
    '''
    informations = []

    try:
        for id in profile_ids:
            informations.append(get_information(id))
    except Exception as message:
        print(str(message))
    return informations

# class print_hello(Resource):
#     '''
#     Exibir o ola mundo.
#     Author: Gugatb
#     Date: 15/06/2018
#     '''
#     def get(self):
        # Inserir o documento.
        # result = db.insert('test', {'Teste': 'key', 'time': str(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))})
        # result = db.insert('test', {'Teste': 'key2'})
        # result = db.insert('test', {'Teste': 'key2'})
        # result = db.update('test', 'ABC', 'Teste', 'XYZ')

        # result = db.read('test', 'key')
        # result = db.readCache('test', 'key', 10)

        # if result is None:
        #     result = db.insert('test', {'Teste': 'key', 'time': str(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))})
        #     result = db.read('test', 'key')

        # html = urllib.request.urlopen('https://python.org/').read()
        #
        # return jsonify(str(html))

        # result = {'data': ['ola', 'mundo']}
        # return jsonify(result)
        # return result
        # return jsonify({'Result': str(db.delete('test', 'key'))})

# class print_params(Resource):
#     '''
#     Exibir os parametros.
#     Author: Gugatb
#     Date: 15/06/2018
#     '''
#     def get(self):
#         parser = reqparse.RequestParser()
#         parser.add_argument('key1', type = str)
#         parser.add_argument('key2', type = str)
#         return parser.parse_args()

# class print_text(Resource):
#     '''
#     Exibir o texto.
#     Author: Gugatb
#     Date: 15/06/2018
#     Param: value o valor
#     '''
#     def get(self, value):
#         result = {'text': value}
#         return jsonify(result)

# api.add_resource(print_hello, '/hello')
# api.add_resource(print_params, '/param', endpoint = 'param')
# api.add_resource(print_text, '/text/<value>')

if __name__ == '__main__':
	# app.run(debug=True, port='8080')
    # print(get_information('00550000006x1XgAAI'))
    print(get_informations(['00550000006x1XgAAI', '00550000006x1XgAAI']))
