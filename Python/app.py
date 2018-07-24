
import re
import urllib.request

from datetime import datetime
from flask import Flask, request
from flask_restful import Resource, Api, reqparse
from flask import jsonify
from mongodb import *

app = Flask(__name__)
api = Api(app)
db = MongoDB()

# Tempo de vida da cache (5 minutos).
time_life = 5 * 60

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

            if len(string) > 0:
                # Remover o '\\n' antes e depois de 'pontos' e 'trilhas'.
                string = string.replace('\\n', '')

                # Definir o id.
                information['profile_id'] = profile_id

                # Obter o nome.
                matches = re.search('<h1 [^>]*data-test-user-name[^>]*>([^<>]*)<\/h1>', string)
                information['name'] = matches.group(1) if matches is not None else ''

                # Obter os emblemas.
                matches = re.search('<div [^>]*data-test-badges-count[^>]*>([^<>]*)<\/div>', string)
                information['badges'] = float(matches.group(1)) if matches is not None else 0

                # Obter os trilhas.
                matches = re.search('<div [^>]*data-test-trails-count[^>]*>([^<>]*)<\/div>', string)
                information['trails'] = float(matches.group(1)) if matches is not None else 0

                # Obter os pontos.
                matches = re.search('<div [^>]*data-test-points-count[^>]*>([^<>]*)<\/div>', string)
                information['points'] = float(matches.group(1)) if matches is not None else 0

                # Inserir o documento na cache.
                db.insert('cache', information)
                del information['_id']
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

@app.route('/information/<profile_id>')
def print_information(profile_id):
    '''
    Imprimir a informacao.
    Author: Gugatb
    Date: 23/07/2018
    Param: information a informacao
    '''
    return jsonify(get_information(profile_id))

@app.route('/informations', methods = ['POST'])
def print_informations():
    '''
    Imprimir a informacao.
    Author: Gugatb
    Date: 23/07/2018
    Param: information a informacao
    '''
    json = request.get_json(force=True)
    return jsonify(get_informations(json))

if __name__ == '__main__':
	app.run(debug=True, port='8080')
