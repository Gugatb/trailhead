
require './mongodb.rb'

require 'json'
require 'open-uri'
require 'sinatra'

# Tempo de vida da cache (5 minutos).
$time_life = 5 * 60

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
    'time' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
  }

  begin
    db = MongoDB.new

    # Ler a cache.
    json = db.readCache('cache', profile_id, $time_life)

    if json == nil
      html = open('https://trailhead.salesforce.com/pt-BR/me/' + profile_id) { |line|
        string = line.read

        if string.length > 0
          # Remover o '\\n' antes e depois de 'pontos' e 'trilhas'.
          string = string.sub('\n', '')

          # Definir o id.
          information['profile_id'] = profile_id

          # Obter o nome.
          information['name'] = string.scan(/<h1 [^>]*data-test-user-name[^>]*>([^<>]*)<\/h1>/imu).flatten.select { |item|
            !item.empty?
          }.first

          # Obter os emblemas.
          information['badges'] = string.scan(/<div [^>]*data-test-badges-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
            !item.empty?
          }.first.to_f

          # Obter os trilhas.
          information['trails'] = string.scan(/<div [^>]*data-test-trails-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
            !item.empty?
          }.first.to_f

          # Obter os pontos.
          information['points'] = string.scan(/<div [^>]*data-test-points-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
            !item.empty?
          }.first.to_f
        end
      }

      # Inserir o documento na cache.
      db.insert('cache', information)
    else
        # Utilizar o documento da cache.
      json = JSON.parse(json)

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
