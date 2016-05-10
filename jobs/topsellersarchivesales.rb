SCHEDULER.every '11m' do

  uri = URI('http://hvsapp.jonpetersen.co.uk/topsellersarchivesales')
  topsellers = Net::HTTP.get(uri)  
  send_event('items3', JSON.parse(topsellers))
end