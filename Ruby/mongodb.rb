
require 'json'
require 'mongo'
require 'neatjson'

class MongoDB
  @@client_host = ['localhost:27017']
  @@client_options = {
    database: 'trailhead',
    # user: 'YOUR_USERNAME',
    # password: 'YOUR_PASSWORD'
  }

  # Deletar o documento.
  # Author: Gugatb
  # Date: 19/06/2018
  # Param: collection_name o nome da colecao
  # Param: id o id do documento
  # Return: counter o contador de documentos deletados
  def delete(collection_name, id)
    counter = 0

    begin
      # Conectar com o banco.
      client = Mongo::Client.new(@@client_host, @@client_options)

      # Deletar o documento.
      result = client[collection_name].find(id: id).delete_many
      result.each { |document| counter = counter + 1 }

      # Fechar a conexao com o banco.
      client.close
    rescue StandardError => message
      puts message
    end
    return counter
  end

  # Inserir o documento.
  # Author: Gugatb
  # Date: 19/06/2018
  # Param: collection_name o nome da colecao
  # Param: document o documento [JSON.parse(document.to_json)]
  # Return: counter o contador de documentos inseridos
  def insert(collection_name, document)
    counter = 0

    begin
      # Conectar com o banco.
      client = Mongo::Client.new(@@client_host, @@client_options)

      # Inserir o documento.
      result = client[collection_name].insert_one(document)
      result.each { |document| counter = counter + 1 }
      # result.inserted_id

      # Fechar a conexao com o banco.
      client.close
    rescue StandardError => message
      puts message
    end
    return counter
  end

  # Ler o documento.
  # Author: Gugatb
  # Date: 19/06/2018
  # Param: collection_name o nome da colecao
  # Param: id o id
  # Return: json o json
  def read(collection_name, id)
    json = []

    begin
      # Conectar com o banco.
      client = Mongo::Client.new(@@client_host, @@client_options)

      # Procurar o documento.
      result = client[collection_name].find(id: id)

      # Iterar o resultado.
      result.each { |document|
        json << JSON.neat_generate(document)
      }

      # Fechar a conexao com o banco.
      client.close
    rescue StandardError => message
      puts message
    end
    return json
  end

  # Atualizar o documento.
  # Author: Gugatb
  # Date: 19/06/2018
  # Param: collection_name o nome da colecao
  # Param: id o id do documento
  # Param: field o campo
  # Param: value o valor
  # Return: counter o contador de documentos atualizados
  def update(collection_name, id, field, value)
    counter = 0

    begin
      # Conectar com o banco.
      client = Mongo::Client.new(@@client_host, @@client_options)

      # Update the document that matches our query below
      result = client[collection_name].find(id: id).update_many('$set' => {field => value})
      result.each { |document| counter = counter + 1 }

      # Fechar a conexao com o banco.
      client.close
    rescue StandardError => message
      puts message
    end
    return counter
  end
end
