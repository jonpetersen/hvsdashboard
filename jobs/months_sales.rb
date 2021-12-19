SCHEDULER.every '2m' do

  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonth')
  current_salesthismonth = Net::HTTP.get(uri)    
  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonthavg')
  current_salesthismonthavg = Net::HTTP.get(uri) 
  
  days_left = Date.new(Time.now.year, Time.now.month, -1).day - Date.today.day
  
  days_left = days_left + 1 if Time.now.hour < 17
  
  days_left = days_left - 2 if Time.now.month == 12
  
  current_salesthismonthforecast = current_salesthismonth.to_f + (days_left * current_salesthismonthavg.to_f)

  send_event('salesthismonth', { current: current_salesthismonth.to_i})
  send_event('salesthismonthavg', { current: current_salesthismonthavg.to_i})
  send_event('salesthismonthforecast', { current: (current_salesthismonthforecast.to_f * 0.93).to_i})
  send_event('salesthisyearforecast', { current: 337000})  
end