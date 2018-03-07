
task :saq_store_scraper => :environment do

  require 'open-uri'
  require 'nokogiri'
  require 'json'

  url = "https://www.saq.com/webapp/wcs/stores/servlet/SAQStoreLocatorSearchResultsView?storeId=20002&catalogId=50000&langId=-1&regionId=Montr%C3%A9al&sousRegionId=&storeType=&beginIndex=0&service=&postalCode=&maxDistance=-1.0&productId=&orderBy=1&pageSize=1000"

  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  puts "Scraping SAQ for stores..."

  html_doc.search('.fiche').each do |element|

    p banner = element.css('.Ban_Selection').text.strip
    p name = element.css('.entete .titre a').inner_html[0..-6].strip
    p address = element.css('.adresse').text.strip.gsub(/\s+/," ").gsub(/(\(|\)|\#)/,"").unicode_normalize(:nfkd).encode('ASCII', replace: '')
    p phoneNumber = element.css('.tel').text.strip[16..27]

    # api call -> geocoder
    geo_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV['GOOGLE_API_SERVER_KEY']}"
    location_serialized = open(geo_url).read
    location = JSON.parse(location_serialized)

    # set gps coordinates
    if location['status'] == "ZERO_RESULTS"
      geo_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address[-6..-1]}&key=#{ENV['GOOGLE_API_SERVER_KEY']}"
      location_serialized = open(geo_url).read
      location = JSON.parse(location_serialized)
      p lat = location['results'][0]['geometry']['location']['lat']
      p lng = location['results'][0]['geometry']['location']['lng']
    else
      p lat = location['results'][0]['geometry']['location']['lat']
      p lng = location['results'][0]['geometry']['location']['lng']
    end

    # identifiers
    p location_id = element.css('.LienBrun').attribute('href').value[107..111].to_i
    p store_identifier = element.css('.LienBrun').attribute('href').value[168..172].to_i

    Store.create(
      banner: banner, name: name, address: address, phone_number: phoneNumber,
      latitude: lat, longitude: lng, location_id: location_id, store_identifier: store_identifier
    )

    puts "-----------"
  end

  puts "Finished!"

end


