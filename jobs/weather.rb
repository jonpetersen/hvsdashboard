require 'uri'
require 'json'
require 'time'
require 'net/http'

weather_hash = {"NA"	=> "Not available",
"0"	=> "Clear night",
"1"	=> "Sunny day",
"2"	=> "Partly cloudy (night)",
"3"	=> "Partly cloudy (day)",
"4"	=> "Not used",
"5"	=> "Mist",
"6"	=> "Fog",
"7"	=> "Cloudy",
"8"	=> "Overcast",
"9"	=> "Light rain shower (night)",
"10" => "Light rain shower (day)",
"11" => "Drizzle",
"12" => "Light rain",
"13" => "Heavy rain shower (night)",
"14" => "Heavy rain shower (day)",
"15" => "Heavy rain",
"16" => "Sleet shower (night)",
"17" => "Sleet shower (day)",
"18" => "Sleet",
"19" => "Hail shower (night)",
"20" => "Hail shower (day)",
"21" => "Hail",
"22" => "Light snow shower (night)",
"23" => "Light snow shower (day)",
"24" => "Light snow",
"25" => "Heavy snow shower (night)",
"26" => "Heavy snow shower (day)",
"27" => "Heavy snow",
"28" => "Thunder shower (night)",
"29" => "Thunder shower (day)",
"30" => "Thunder"}

SCHEDULER.every '1m' do

  #metoffice API key 1b699c25-9a2a-49ca-817f-912dd6e127a0
  #<Location elevation="70.0" id="352887" latitude="51.1324" longitude="-0.6224" name="Oakhurst Cottage Hambledon" region="se" unitaryAuthArea="Surrey"/>
    
  #client = MetofficeDatapoint.new(api_key: '1b699c25-9a2a-49ca-817f-912dd6e127a0')
  #resolution ='3hourly'
  #id = '352887'
  #site_forecast = client.forecasts(id, {res: resolution})
  
  uri = URI('http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/json/352887?res=3hourly&key=1b699c25-9a2a-49ca-817f-912dd6e127a0')
  site_forecast = JSON.parse(Net::HTTP.get(uri))
  current_weather_data = site_forecast['SiteRep']['DV']['Location']['Period'][0]['Rep']
  
  if Time.now.hour < 2 || Time.now.hour == 23
    weather_time = "0" 
  elsif Time.now.hour == 2 || Time.now.hour == 3 || Time.now.hour == 4
    weather_time = "180"
  elsif Time.now.hour == 5 || Time.now.hour == 6 || Time.now.hour == 7 
    weather_time = "360"
  elsif Time.now.hour == 8 || Time.now.hour == 9 || Time.now.hour == 10 
    weather_time = "540"
  elsif Time.now.hour == 11 || Time.now.hour == 12 || Time.now.hour == 13 
    weather_time = "720"
  elsif Time.now.hour == 14 || Time.now.hour == 15 || Time.now.hour == 16 
    weather_time = "900"
  elsif Time.now.hour == 17 || Time.now.hour == 18 || Time.now.hour == 19 
    weather_time = "1080"
  elsif Time.now.hour == 20 || Time.now.hour == 21 || Time.now.hour == 22 
    weather_time = "1260"
  end  
        
  now_weather_data = current_weather_data.select{|key, hash| key["$"] == weather_time }  
  current_temp = now_weather_data[0]["T"]
  current_weather = now_weather_data[0]["W"]
  current_weather = weather_hash.select { |key,_| key.eql? current_weather } 
  current_weather = current_weather.to_a[0][1]
  
  #uri = URI('http://api.wunderground.com/api/ef5428a7deb2ce62/conditions/q/pws:IHAMBLED3.json')
  #uri = URI('http://api.wunderground.com/api/ef5428a7deb2ce62/conditions/q/pws:ISURREYM2.json')
  #current_weather_data = JSON.parse(Net::HTTP.get(uri))
  #current_temp = current_weather_data["current_observation"]["temp_c"]
  #current_weather = current_weather_data["current_observation"]["weather"]
  #send_event('current_temp', { current: current_temp})
  #send_event('current_weather', { current: current_weather})
  
  send_event('weather', { :temp => "#{current_temp}&deg;C",
                          :condition => current_weather,
                          :title => "Current Weather",
                          :climacon => climacon_class(current_weather)})
end

def climacon_class(weather_code)
  case weather_code
  when "Sunny day" 
    'sun'
  when "Partly cloudy (day)" 
    'cloud sun'
  when "Partly cloudy (night)" 
    'cloud sun'
  when "Cloudy" 
    'cloud'
  when "Light rain" 
    'drizzle'
  when "Haze" 
    'haze'
  when "Heavy rain" 
    'umbrella'
  
  end
end   
