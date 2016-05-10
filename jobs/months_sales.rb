SCHEDULER.every '4m' do

  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonth')
  current_salesthismonth = Net::HTTP.get(uri)    
  uri = URI('http://hvsapp.jonpetersen.co.uk/salesthismonthavg')
  current_salesthismonthavg = Net::HTTP.get(uri) 

  send_event('salesthismonth', { current: current_salesthismonth.to_i})
  send_event('salesthismonthavg', { current: current_salesthismonthavg.to_i})
end