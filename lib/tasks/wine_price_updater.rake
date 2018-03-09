task :wine_price_updater => :environment do
  require "nokogiri"
  require "open-uri"

  url = "https://www.saq.com/webapp/wcs/stores/servlet/SearchDisplay?minPrice=999&maxPrice=&langId=-1&storeId=20002&catalogId=50000&beginIndex=0&orderBy=5&pageSize=100&searchTerm=*&searchType=&metaData=YWRpX2YxOjA8TVRAU1A%2BYWRpX2Y5OiIxIjxNVEBTUD5hZGlfZjk6MQ%3D%3D&facet=&pageView=grid&filterFacet=&categoryIdentifier=06&showOnly=product"
  page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

  page.css("div.wrapper-middle-rech").map do |content|

      (0..3).each do |i|
        image = content.css("div.img a")[i]["id"]
        image = image[image.index("_")+1..-1]
        wine = Wine.where(saq_code: image)

        p price = content.css("td.price a")[i].text
        p price2 = (price[1..-1].gsub(/(\.|\,)/,"").to_f) / 100

        wine.update(price: price2)
      end
  end
  puts "Scraping complete!"
end
