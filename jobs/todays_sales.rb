current_salesvalue = 0
current_salesthismonth = 0
current_saleslasttime = ""

SCHEDULER.every '10s' do
  last_salesvalue = YAML::load_file('tmp/todays_sales.yml')
  last_salesvalue = -1 if Time.now.hour == 6
  
  current_salesvalue = Net::HTTP.get(URI('http://hvsapp.jonpetersen.co.uk/salestoday'))
  current_saleslast = Net::HTTP.get(URI('http://hvsapp.jonpetersen.co.uk/salelasttime'))
  current_vattodaypercent = Net::HTTP.get(URI('http://hvsapp.jonpetersen.co.uk/vattoday'))
  if current_saleslast == "EOD"
	current_saleslasttime = "EOD"
    lastsaleoperator = "The Shop has closed"
  else
    current_saleslasttime = JSON.parse(current_saleslast)["time"]
    current_saleslastoperator = JSON.parse(current_saleslast)["operator"]
    lastsaleoperator = current_saleslastoperator + " - " + current_saleslasttime
  end
    
  current_transactionsrecent = Net::HTTP.get(URI('http://hvsapp.jonpetersen.co.uk/transactionsrecent'))
  current_transactionscolour = "green"
  current_transactionscolour = "red" if current_transactionsrecent.to_i > 5 

  if current_salesvalue.to_i > last_salesvalue
    File.open('tmp/todays_sales.yml', 'w') {|f| f.write current_salesvalue.to_i.to_yaml } #Store
  elsif Time.now.hour > 22
    File.open('tmp/todays_sales.yml', 'w') {|f| f.write 0.to_yaml }
  else
    current_salesvalue = last_salesvalue
  end
  
  send_event('salesvalue', { current: current_salesvalue.to_i})
  send_event('lastsaletime', { current: current_saleslasttime})
  send_event('lastsaleoperator', { text: lastsaleoperator})
  send_event('transactionsrecent', { current: current_transactionsrecent, colour: current_transactionscolour})
  send_event('vattodaypercent', { current: current_vattodaypercent})
end

