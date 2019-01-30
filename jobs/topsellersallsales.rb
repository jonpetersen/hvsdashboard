SCHEDULER.every '10m' do

  uri = URI('https://hvsapp.jonpetersen.co.uk/topsellersallsales')
  topsellers = Net::HTTP.get(uri)  
  send_event('items2', JSON.parse(topsellers))
end