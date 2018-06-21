
from flask import Flask, request
from flask_restful import Resource, Api, reqparse
from flask import jsonify
from mongodb import *

app = Flask(__name__)
api = Api(app)
db = MongoDB()

class print_hello(Resource):
    '''
    Exibir o ola mundo.
    Author: Gugatb
    Date: 15/06/2018
    '''
    def get(self):
        # Inserir o documento.
        # result = db.insert('test', {'Teste': 'key'})
        
        result = db.read('test', 'key')

        # result = {'data': ['ola', 'mundo']}
        return jsonify(result)

class print_params(Resource):
    '''
    Exibir os parametros.
    Author: Gugatb
    Date: 15/06/2018
    '''
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('key1', type = str)
        parser.add_argument('key2', type = str)
        return parser.parse_args()

class print_text(Resource):
    '''
    Exibir o texto.
    Author: Gugatb
    Date: 15/06/2018
    Param: value o valor
    '''
    def get(self, value):
        result = {'text': value}
        return jsonify(result)

api.add_resource(print_hello, '/hello')
api.add_resource(print_params, '/param', endpoint = 'param')
api.add_resource(print_text, '/text/<value>')

if __name__ == '__main__':
	app.run(debug=True, port='18080')
