
import json

from datetime import datetime
from pymongo import MongoClient

client = MongoClient('localhost', 27017)

client_database = 'trailhead'
client_db = client[client_database]

class MongoDB:
    def delete(self, collection_name, id):
        counter = 0

        try:
            result = client_db[collection_name].delete_many({'profile_id': id})
            counter = int(result.deleted_count)
            
        except Exception as message:
            print(str(message))
        return counter


    def insert(self, collection_name, document):
        counter = 0

        try:
            result = client_db[collection_name].insert_one(document)

            if result is not None:
                counter = 1
                
        except Exception as message:
            print(str(message))
        return counter

    def read(self, collection_name, id):
        try:
            for document in client_db[collection_name].find({'profile_id': id}):
                return str(document)
            
        except Exception as message:
            print(str(message))
        return None

    def readCache(self, collection_name, id, time_life):
        try:
            for document in client_db[collection_name].find({'profile_id': id}):
                time1 = datetime.strptime(document['time'], "%Y-%m-%d %H:%M:%S")
                time2 = datetime.now()

                if (time2 - time1).total_seconds() < time_life:
                    return document
                else:
                    client_db[collection_name].delete_many({'profile_id': id})
                    break
                
        except Exception as message:
            print(str(message))
        return None

    def update(self, collection_name, id, field, value):
        counter = 0

        try:
            result = client_db[collection_name].update_many({'profile_id': id}, {'$set': {field: value}})
            counter = int(result.modified_count)
            
        except Exception as message:
            print(str(message))
        return counter
