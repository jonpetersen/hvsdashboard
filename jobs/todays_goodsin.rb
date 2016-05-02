current_salesvalue = 0
current_salesthismonth = 0
current_saleslasttime = ""

SCHEDULER.every '10m' do
  last_salesvalue = current_salesvalue

  uri = URI('http://hvsapp.jonpetersen.co.uk/goodsinrecent')
  current_goodsinrecent = Net::HTTP.get(uri)
  
  send_event('goodsinrecent', { current: current_goodsinrecent})
end