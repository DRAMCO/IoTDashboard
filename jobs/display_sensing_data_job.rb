require 'net/http'
require 'uri'
require 'json'

SCHEDULER.every "1m", first_in: 0 do |job|
  puts "================================= TTN ======================================"
  uri = URI.parse("https://jsonblob.com/api/jsonBlob/a0ad9800-8cc0-11e7-8b46-a1d5479b81f6")
  request = Net::HTTP::Get.new(uri)
  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  if response.code == "200"
    users = JSON.parse(response.body)
    puts "Users: #{users}"

    series_temperature = []
    series_humidity = []

    min = 1000
    max = -1000

    users.each do |user|
      uri = URI.parse("https://"+user["applicationID"]+".data.thethingsnetwork.org/api/v2/query?last=10m")
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
      request["Authorization"] = "key "+ user["key"]

      puts "Request URI: #{uri}"
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      # puts "Response: #{response.body}"

      # response.code
      # response.body

      if response.code == "200"
        messages = JSON.parse(response.body)
        i = 0
        data = []
        last_data = 0
        messages.each do |message|
          unless message['temperature'].nil?
            temperature = message['temperature']
            JSON.parse(temperature.gsub(/\s/,',')).each do |sample|
              if(sample.to_f > max)
                max = sample.to_f
              end
              if(sample.to_f < min)
                min = sample.to_f
              end
              data.push({"x"=> i, "y" => sample.to_f})
              last_data = sample.to_f
              i = i + 1
            end
          end
        end

        series_temperature.push({name: user["applicationID"], data: data});


        i = 0
        data = []
        last_data = 0
        messages.each do |message|
          unless message['humidity'].nil?
            temperature = message['humidity']
            JSON.parse(temperature.gsub(/\s/,',')).each do |sample|
              if(sample.to_f > max)
                max = sample.to_f
              end
              if(sample.to_f < min)
                min = sample.to_f
              end
              data.push({"x"=> i, "y" => sample.to_f})
              last_data = sample.to_f
              i = i + 1
            end
          end
        end

        series_humidity.push({name: user["applicationID"], data: data});


      else
        if response.code != "204"
          puts "ERROR!"
        end
      end

    end # users.end

  end
  puts "Temp Series: #{series_temperature}"
  send_event('temperature_value', series: series_temperature)
  puts "Hum Series: #{series_humidity}"
  send_event('humidity_value', series: series_humidity)

  puts "================================= TTN ======================================"
end
