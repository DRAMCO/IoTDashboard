require "net/http"
require "json"

# WOEID for location:
# http://woeid.rosselliot.co.nz
woeid  = 970013

# Units for temperature:
# f: Fahrenheit
# c: Celsius
format = "c"

query  = URI::encode "select * from weather.forecast WHERE woeid=#{woeid} and u='#{format}'&format=json"

SCHEDULER.every "5m", :first_in => "2s" do |job|
  # Yahoo Weather API
  begin 
    yHttp     = Net::HTTP.new "query.yahooapis.com"
    yRequest  = yHttp.request Net::HTTP::Get.new("/v1/public/yql?q=#{query}")
    yResponse = JSON.parse yRequest.body
    yResults  = yResponse["query"]["results"]
  rescue StandardError 
    print "Error getting Yahoo weather API."
  end

  # Buienradar API
  begin 
    bHttp     = Net::HTTP.new "br-gpsgadget-new.azurewebsites.net"
    bRequest  = bHttp.request Net::HTTP::Get.new("/data/raintext/?lat=51.05&lon=3.72")
    bResponse = bRequest.body
    bValues   = bResponse.split("\r\n")
  rescue StandardError
    print "Error getting Buienradar API."
  end
  
  i = 0
  buienradar = []
  bValues.each do |rain|
  	rainValues   = rain.split("|")
  	buienradar.push({x: i, y: Integer(rainValues[0],10)})
  	i = i + 1
  end
  buienradar

  if yResults
    condition = yResults["channel"]["item"]["condition"]
    location  = yResults["channel"]["location"]
    forecast = yResults["channel"]["item"]["forecast"]
    maxTemperatures = []
    i = 0
    forecast.each do |weather|
    	maxTemperatures.push({x: i, y: Integer(weather["high"])})
    	i = i+1
    end
    maxTemperatures

    send_event "klimato", { location: location["city"], temperature: condition["temp"], code: condition["code"], format: format, maxTemperatures: maxTemperatures, rainForecast: buienradar }
  end
end
