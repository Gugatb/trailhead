
require './mongodb.rb'

require 'json'
require 'open-uri'
require 'sinatra'

$time_life = 5 * 60

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

    json = db.readCache('cache', profile_id, $time_life)

    if json == nil
      html = open('https://trailhead.salesforce.com/pt-BR/me/' + profile_id) { |line|
        string = line.read

        if string.length > 0
          string = string.sub('\n', '')
          information['profile_id'] = profile_id

          information['name'] = string.scan(/<h1 [^>]*data-test-user-name[^>]*>([^<>]*)<\/h1>/imu).flatten.select { |item|
            !item.empty?
          }.first

          information['badges'] = string.scan(/<div [^>]*data-test-badges-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
            !item.empty?
          }.first.to_f

          information['trails'] = string.scan(/<div [^>]*data-test-trails-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
            !item.empty?
          }.first.to_f

          information['points'] = string.scan(/<div [^>]*data-test-points-count[^>]*>([^<>]*)<\/div>/imu).flatten.select { |item|
            !item.empty?
          }.first.to_f
        end
      }

      db.insert('cache', information)
    else
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

set :port, 8080

get '/information/:profile_id' do
  get_information(params[:profile_id]).to_json
end

post "/informations" do
  profile_ids = []

  JSON.parse(request.body.read).each { |id|
    profile_ids << id
  }

  get_informations(profile_ids).to_json
end
