
require 'json'
require 'mongo'
require 'neatjson'

class MongoDB
  @@client_host = ['localhost:27017']
  @@client_options = {
    database: 'trailhead'
    # pool_size: 50,
    # pool_timeout: 10
    # user: 'YOUR_USERNAME',
    # password: 'YOUR_PASSWORD'
  }

  @@client = Mongo::Client.new(@@client_host, @@client_options)

  def delete(collection_name, id)
    counter = 0

    begin
      result = @@client[collection_name].find(profile_id: id).delete_many
      result.each { |document| counter = counter + 1 }

    rescue StandardError => message
      puts message
    end
    return counter
  end

  def insert(collection_name, document)
    counter = 0

    begin
      result = @@client[collection_name].insert_one(document)
      result.each { |document| counter = counter + 1 }

    rescue StandardError => message
      puts message
    end
    return counter
  end

  def read(collection_name, id)
    json = nil

    begin
      result = @@client[collection_name].find(profile_id: id)
      json = JSON.neat_generate(result.first)

    rescue StandardError => message
      puts message
    end
    return json
  end

  def readCache(collection_name, id, time_life)
    json = nil

    begin
      result = @@client[collection_name].find(profile_id: id)

      if result != nil
        first = JSON.neat_generate(result.first)
        time1 = Time.strptime(JSON.parse(first)['time'], "%Y-%m-%d %H:%M:%S")
        time2 = Time.now

        if time2 - time1 < time_life
          json = first
        else
          result.delete_many
        end
      end

    rescue StandardError => message
      puts message
    end
    return json
  end

  def update(collection_name, id, field, value)
    counter = 0

    begin
      result = client[collection_name].find(profile_id: id).update_many('$set' => {field => value})
      result.each { |document| counter = counter + 1 }
	  
    rescue StandardError => message
      puts message
    end
    return counter
  end
end
