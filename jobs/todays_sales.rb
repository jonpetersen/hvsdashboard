current_salesvalue = 0
current_salesthismonth = 0
current_saleslasttime = ""

SCHEDULER.every '20s' do
  last_salesvalue = current_salesvalue

  uri = URI('http://hvsapp.jonpetersen.co.uk/salestoday')
  current_salesvalue = Net::HTTP.get(uri)
  uri = URI('http://hvsapp.jonpetersen.co.uk/salelasttime')
  current_saleslast = (Net::HTTP.get(uri))
  uri = URI('http://hvsapp.jonpetersen.co.uk/vattoday')
  current_vattodaypercent = (Net::HTTP.get(uri))
  if current_saleslast == "EOD"
	current_saleslasttime = "EOD"
  else
    current_saleslasttime = JSON.parse(current_saleslast)["time"]
    current_saleslastoperator = JSON.parse(current_saleslast)["operator"]
  end
    
  uri = URI('http://hvsapp.jonpetersen.co.uk/transactionsrecent')
  current_transactionsrecent = Net::HTTP.get(uri)
  current_transactionscolour = "green"
  current_transactionscolour = "red" if current_transactionsrecent.to_i > 5 

  send_event('salesvalue', { current: current_salesvalue.to_i})
  send_event('lastsaletime', { current: current_saleslasttime})
  send_event('lastsaleoperator', { text: current_saleslastoperator})
  send_event('transactionsrecent', { current: current_transactionsrecent, colour: current_transactionscolour})
  send_event('vattodaypercent', { current: current_vattodaypercent})
end