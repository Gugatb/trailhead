
require 'json'
require 'open-uri'
require 'sinatra'

# Obter a informacao.
# Author: Gugatb
# Date: 18/06/2018
# Return: information a informacao
def get_information(id)
  information = {
    'name' => '',
    'badges' => 0,
    'trails' => 0,
    'points' => 0
  }

  begin
    source = open('https://trailhead.salesforce.com/pt-BR/me/' + id) { |file|
      # Obter a linha.
      line = file.read

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
  rescue Exception => message
    puts message
  end
  return information
end

# Obter as informacoes.
# Author: Gugatb
# Date: 18/06/2018
# Return: informations as informacoes
def get_informations(ids)
  informations = []

  begin
    ids.each { |id|
      informations << get_information(id)
    }
  rescue Exception => message
    puts message
  end
  return informations
end

# Definir a porta.
set :port, 8080

get '/information/:id' do
  get_information(params[:id]).to_json
end

post "/informations" do
  ids = []

  # Obter os ids.
  JSON.parse(request.body.read).each { |item|
    ids << item
  }

  # Obter as informacoes.
  get_informations(ids).to_json
end
