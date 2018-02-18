SCHEDULER.every '4m' do

  uri = URI('http://hvsapp.jonpetersen.co.uk/topsellerstodaysales')
  topsellers = Net::HTTP.get(uri)  
  send_event('items1', JSON.parse(topsellers))
end