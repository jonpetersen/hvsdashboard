current_salesvalue = 0

SCHEDULER.every '60s' do
  last_salesvalue = current_salesvalue

  uri = URI('http://hvsapp.jonpetersen.co.uk/eodtotal')
  current_salesvalue = Net::HTTP.get(uri)

  send_event('salesvalue', { current: current_salesvalue})
end