
import json

from pymongo import MongoClient

# Cliente com o MongoDB.
client = MongoClient('localhost', 27017)

# Propriedades do cliente.
client_database = 'trailhead'
client_db = client[client_database]

class MongoDB:
    def delete(self, collection_name, id):
        """
        Deletar o documento.
        Author: Gugatb
        Date: 21/06/2018
        Param: collection_name  o nome da colecao
        Param: id o id do documento
        Return: counter o contador de documentos deletados
        """
        counter = 0

        try:
            # Deletar o documento.
            result = client_db[collection_name].delete_many({'Teste': id})
            counter = int(result.deleted_count)
        except Exception as message:
            print(str(message))
        return counter


    def insert(self, collection_name, document):
        """
        Deletar o documento.
        Author: Gugatb
        Date: 21/06/2018
        Param: collection_name  o nome da colecao
        Param: document do documento
        Return: counter o contador de documentos inseridos
        """
        counter = 0

        try:
            # Inserir o documento.
            result = client_db[collection_name].insert_one(document)

            if result is not None:
                counter = 1
        except Exception as message:
            print(str(message))
        return counter

    def read(self, collection_name, id):
        """
        Ler o documento.
        Author: Gugatb
        Date: 21/06/2018
        Param: collection_name  o nome da colecao
        Param: id o id do documento
        Return: counter o contador de documentos inseridos
        """
        json = None

        try :
            for document in client_db[collection_name].find({'Teste': id}):
                return str(document))
        except Exception as message:
            print(str(message))
        return json
