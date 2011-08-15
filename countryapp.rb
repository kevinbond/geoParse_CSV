require 'uri'
require 'rest_client'
require 'json'
require 'crack'
require 'csv'

data = CSV.read("/Users/kevinbond/Sites/countrycodes.csv")

data[0][2] = "Capital"
data[0][3] = "Longitude"
data[0][4] = "Latitude"

csv = CSV.open("newCSVFile.csv", "wb")
csv << ["#{data[0][0]}" , " #{data[0][1]}", " #{data[0][2]}", " #{data[0][3]}", " #{data[0][4]}"]

for i in 1..(data.length - 1)
  country = data[i][1]

  url = "http://www.geognos.com/api/en/countries/info/#{country}.json"
  info = RestClient.get(url)
  info = JSON.parse(info)

  if info["Results"]["Capital"].nil?
    capital = "No Capital!"
    data[i][2] = capital
    data[i][3] = "N/A"
    data[i][4] = "N/A"

  else
    capital = info["Results"]["Capital"]["Name"]
    data[i][2] = "#{capital}"
    url = URI.encode("http://where.yahooapis.com/geocode?location=#{data[i][1]},#{capital}&appid=YD-9G7bey8_JXxQP6rxl.fBFGgCdNjoDMACQA--")
    info = RestClient.get(url)
    coordinates = Crack::XML.parse(info)

    if coordinates["ResultSet"]["Found"] != "1" 
      long = coordinates["ResultSet"]["Result"][0]["longitude"]
      data[i][3] = long
      lat = coordinates["ResultSet"]["Result"][0]["latitude"]
      data[i][4] = lat
    else
      long = coordinates["ResultSet"]["Result"]["longitude"]
      data[i][3] = long
      lat = coordinates["ResultSet"]["Result"]["latitude"]
      data[i][4] = lat
    end
  end

  csv << ["#{data[i][0]}" , " #{data[i][1]}", " #{data[i][2]}", " #{data[i][3]}", " #{data[i][4]}"]
end

puts"file is updated! Thank you!"