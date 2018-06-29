
import json

from datetime import datetime
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
        try:
            for document in client_db[collection_name].find({'Teste': id}):
                return str(document)
        except Exception as message:
            print(str(message))
        return None

    def readCache(self, collection_name, id, time_life):
        """
        Ler o documento da cache.
        Author: Gugatb
        Date: 28/06/2018
        Param: collection_name  o nome da colecao
        Param: id o id do documento
        Param: time_life o tempo de vida
        Return: json o json
        """
        try:
            for document in client_db[collection_name].find({'Teste': id}):
                time1 = datetime.strptime(document['time'], "%Y-%m-%d %H:%M:%S")
                time2 = datetime.now()

                # Verificar se o tempo de vida terminou.
                if (time2 - time1).total_seconds() < time_life:
                    return str(document)
                else:
                    # Se o tempo de vida terminou, apagar o documento.
                    client_db[collection_name].delete_many({'Teste': id})
                    break
        except Exception as message:
            print(str(message))
        return None

    def update(self, collection_name, id, field, value):
        """
        Atualizar o documento.
        Author: Gugatb
        Date: 28/06/2018
        Param: collection_name  o nome da colecao
        Param: id o id do documento
        Param: field o campo
        Param: value o valor
        Return: counter o contador de documentos atualizados
        """
        counter = 0

        try:
            # Atualizar o documento.
            result = client_db[collection_name].update_many({'Teste': id}, {'$set': {field: value}})
            counter = int(result.modified_count)
        except Exception as message:
            print(str(message))
        return counter
