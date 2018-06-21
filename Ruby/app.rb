
require './mongodb.rb'

require 'json'
require 'open-uri'
require 'sinatra'

# Tempo de vida da cache (5 minutos).
$time_life = 20 #5 * 60

# Obter a informacao.
# Author: Gugatb
# Date: 18/06/2018
# Param: profile_id o id do perfil
# Return: information a informacao
def get_information(profile_id)
  information = {
    'profile_id' => '',
    'name' => '',
    'badges' => 0,
    'trails' => 0,
    'points' => 0,
    'time' => Time.now.to_s
  }

  begin
    db = MongoDB.new

    # Ler a cache.
    json = db.readCache('cache', profile_id, $time_life)

    if json.size == 0
      source = open('https://trailhead.salesforce.com/pt-BR/me/' + profile_id) { |file|
        # Obter a linha.
        line = file.read

        # Definir o id.
        information['profile_id'] = profile_id

        # Obter o nome.
        information['name'] = line.scan(/<h1 [^>]*data-test-user-name[^>]*>([^<>]*)<\/h1>/imu).flatten.select { |item|
          !item.empty?
        }.first

        # Obter os emblemas.
        information['badges'] = line.scan(/<div [^>]*class=\'user-information__achievements-data\' data-test-badges-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
          !item.empty?
        }.first.to_i

        # Obter os trilhas.
        information['trails'] = line.scan(/<div [^>]*class=\'user-information__achievements-data\' data-test-trails-count[^>]*>\n([^<>]*)\n<\/div>/imu).flatten.select { |item|
          !item.empty?
        }.first.to_i

        # Obter os pontos.
        information['points'] = line.scan(/<div [^>]*class=\'user-information__achievements-data\' data-test-points-count[^>]*>\n([^<>]*)\n<\/div>/imu).flatten.select { |item|
          !item.empty?
        }.first.to_i
      }

      # Inserir o documento na cache.
      db.insert('cache', information)
    else
        # Utilizar o documento da cache.
      json = JSON.parse(json.first)

      information = {
        'profile_id' => json['profile_id'],
        'name' => json['name'],
        'badges' => json['badges'],
        'trails' => json['trails'],
        'points' => json['points'],
        'time' => json['time']
      }
    end
  rescue Exception => message
    puts message
  end
  return information
end

# Obter as informacoes.
# Author: Gugatb
# Date: 18/06/2018
# Param: profile_ids os ids de perfis
# Return: informations as informacoes
def get_informations(profile_ids)
  informations = []

  begin
    profile_ids.each { |id|
      informations << get_information(id)
    }
  rescue Exception => message
    puts message
  end
  return informations
end

# Definir a porta.
set :port, 8080

get '/information/:profile_id' do
  get_information(params[:profile_id]).to_json
end

post "/informations" do
  profile_ids = []

  # Obter os ids de perfis.
  JSON.parse(request.body.read).each { |id|
    profile_ids << id
  }

  # Obter as informacoes.
  get_informations(profile_ids).to_json
end
