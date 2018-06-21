
require 'json'
require 'mongo'
require 'neatjson'

class MongoDB
  # Propriedades do cliente.
  @@client_host = ['localhost:27017']
  @@client_options = {
    database: 'trailhead'
    # pool_size: 50,
    # pool_timeout: 10
    # user: 'YOUR_USERNAME',
    # password: 'YOUR_PASSWORD'
  }

  # Cliente com o MongoDB.
  @@client = Mongo::Client.new(@@client_host, @@client_options)

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
      # client = Mongo::Client.new(@@client_host, @@client_options)

      # Deletar o documento.
      result = @@client[collection_name].find(profile_id: id).delete_many
      result.each { |document| counter = counter + 1 }

      # Fechar a conexao com o banco.
      # client.close
    rescue StandardError => message
      puts message
    end
    return counter
  end

  # Inserir o documento.
  # Author: Gugatb
  # Date: 19/06/2018
  # Param: collection_name o nome da colecao
  # Param: document o documento
  # Return: counter o contador de documentos inseridos
  def insert(collection_name, document)
    counter = 0

    begin
      # Conectar com o banco.
      # client = Mongo::Client.new(@@client_host, @@client_options)

      # Inserir o documento.
      result = @@client[collection_name].insert_one(document)
      result.each { |document| counter = counter + 1 }
      # result.inserted_id

      # Fechar a conexao com o banco.
      # client.close
    rescue StandardError => message
      puts message
    end
    return counter
  end

  # Ler o documento.
  # Author: Gugatb
  # Date: 19/06/2018
  # Param: collection_name o nome da colecao
  # Param: id o id do documento
  # Return: json o json
  def read(collection_name, id)
    json = []

    begin
      # Conectar com o banco.
      # client = Mongo::Client.new(@@client_host, @@client_options)

      # Procurar o documento.
      result = @@client[collection_name].find(profile_id: id)

      # Iterar o resultado.
      result.each { |document|
        json << JSON.neat_generate(document)
      }

      # Fechar a conexao com o banco.
      # client.close
    rescue StandardError => message
      puts message
    end
    return json
  end

  # Ler o documento da cache.
  # Author: Gugatb
  # Date: 20/06/2018
  # Param: collection_name o nome da colecao
  # Param: id o id do documento
  # Param: time_life o tempo de vida
  # Return: json o json
  def readCache(collection_name, id, time_life)
    json = []

    begin
      # Conectar com o banco.
      # client = Mongo::Client.new(@@client_host, @@client_options)

      # Procurar o documento.
      result = @@client[collection_name].find(profile_id: id)

      if result != nil
        first = JSON.neat_generate(result.first)
        time1 = Time.parse(Time.now.to_s)
        time2 = Time.parse(JSON.parse(first)['time'])

        # Verificar se o tempo de vida terminou.
        if time1 - time2 < time_life
          json << first
        else
          # Se o tempo de vida terminou, apagar o documento.
          result.delete_many
        end
      end

      # Fechar a conexao com o banco.
      # client.close
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
      # client = Mongo::Client.new(@@client_host, @@client_options)

      # Update the document that matches our query below
      result = client[collection_name].find(profile_id: id).update_many('$set' => {field => value})
      result.each { |document| counter = counter + 1 }

      # Fechar a conexao com o banco.
      # client.close
    rescue StandardError => message
      puts message
    end
    return counter
  end
end
