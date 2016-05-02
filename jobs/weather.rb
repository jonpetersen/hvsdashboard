require 'uri'

SCHEDULER.every '8m' do

  uri = URI('http://api.wunderground.com/api/ef5428a7deb2ce62/conditions/q/pws:IHAMBLED3.json')
  current_weather_data = JSON.parse(Net::HTTP.get(uri))
  current_temp = current_weather_data["current_observation"]["temp_c"]
  current_weather = current_weather_data["current_observation"]["weather"]
  #send_event('current_temp', { current: current_temp})
  #send_event('current_weather', { current: current_weather})
  
  send_event('weather', { :temp => "#{current_temp.round}&deg;C",
                          :condition => current_weather,
                          :title => "Current Weather",
                          :climacon => climacon_class(current_weather)})
end

def climacon_class(weather_code)
  case weather_code
  when "Clear" 
    'sun'
  when "Partly Cloudy" 
    'cloud sun'
  when "Scattered Clouds" 
    'cloud sun'
  when "Mostly Cloudy" 
    'cloud sun'
  end
end   
#  when 0 
#    'tornado'
#  when 1 
#    'tornado'
#  when 2 
#    'tornado'
#  when 3 
#    'lightning'
#  when 4 
#    'lightning'
#  when 5 
#    'snow'
#  when 6 
#    'sleet'
#  when 7 
#    'snow'
#  when 8 
#    'drizzle'
#  when 9 
#    'drizzle'
#  when 10 
#    'sleet'
#  when 11 
#    'rain'
#  when 12 
#    'rain'
#  when 13 
#    'snow'
#  when 14 
#    'snow'
#  when 15 
#    'snow'
#  when 16 
#    'snow'
#  when 17 
#    'hail'
#  when 18 
#    'sleet'
#  when 19 
#    'haze'
#  when 20 
#    'fog'
#  when 21 
#    'haze'
#  when 22 
#    'haze'
#  when 23 
#    'wind'
#  when 24 
#    'wind'
#  when 25 
#    'thermometer low'
#  when 26 
#    'cloud'
#  when 27 
#    'cloud moon'
#  when 28 
#    'cloud sun'
#  when 29 
#    'cloud moon'
#  when 30 
#    'cloud sun'
#  when 31 
#    'moon'
#  when 32 
#    'sun'
#  when 33 
#    'moon'
#  when "Clear" 
#    'sun'
#  when 35 
#    'hail'
#  when 36 
#    'thermometer full'
#  when 37 
#    'lightning'
#  when 38 
#    'lightning'
#  when 39 
#    'lightning'
#  when 40 
#    'rain'
#  when 41 
#    'snow'
#  when 42 
#    'snow'
#  when 43 
#    'snow'
#  when 44 
#    'cloud'
#  when 45 
#    'lightning'
#  when 46 
#    'snow'
#  when 47 
#    'lightning'
