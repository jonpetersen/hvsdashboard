SCHEDULER.every '5m' do

  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonth')
  current_salesthismonth = Net::HTTP.get(uri)    
  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonthavg')
  current_salesthismonthavg = Net::HTTP.get(uri) 
  
  days_left = Date.new(Time.now.year, Time.now.month, -1).day - Date.today.day
  
  days_left = days_left + 1 if Time.now.hour < 17
  
  current_salesthismonthforecast = current_salesthismonth.to_f + (days_left * current_salesthismonthavg.to_f)

  send_event('salesthismonth', { current: current_salesthismonth.to_i})
  send_event('salesthismonthavg', { current: current_salesthismonthavg.to_i})
  send_event('salesthismonthforecast', { current: current_salesthismonthforecast})  
end