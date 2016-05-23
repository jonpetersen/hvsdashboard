SCHEDULER.every '4m' do

  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonth')
  current_salesthismonth = Net::HTTP.get(uri)    
  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonthavg')
  current_salesthismonthavg = Net::HTTP.get(uri) 
  
  days_left = Time.now.end_of_month.day - Date.today.day
  
  current_salesthismonthforecast = current_salesthismonth.to_f + (days_left + 1) * current_salesthismonthavg.to_f

  send_event('salesthismonth', { current: current_salesthismonth.to_i})
  send_event('salesthismonthavg', { current: current_salesthismonthavg.to_i})
  send_event('salesthismonthforecast', { current: current_salesthismonthforecast})  
end