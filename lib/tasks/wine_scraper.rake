task :wine_scraper => :environment do
  require "nokogiri"
  require "open-uri"

  puts "Please enter begin index"
  begin_index = STDIN.gets.chomp

  puts "Please enter page size"
  page_size = STDIN.gets.chomp

  urls = ["https://www.saq.com/webapp/wcs/stores/servlet/AjaxProduitSearchResultView?facetSelectionCommandName=SearchDisplay&searchType=&originalSearchTerm=*&orderBy=1&categoryIdentifier=06&showOnly=product&langId=-1&beginIndex=#{begin_index}&metaData=&pageSize=#{page_size}&catalogId=50000&searchTerm=*&pageView=grid&facet=&categoryId=39919&storeId=20002&orderByType=2&filterFacet="]

  urls.each do |url|

    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    page.css("div.wrapper-middle-rech").map do |content|

      (0..3).each do |i|
        wine = Wine.new

        if content.css("p.nom a")[i] != nil
          name = content.css("td.price .hors-ecran")[i].text.strip.split(",")[0]
          wine.name = name
          p wine.name

          # Retrieve wine vintage
          if name[-4..-3] == "20" || name[-4..-3] == "19"
            year = name[-4..-1]
            wine.year = year
          end
          p wine.year

          urlProd = content.css("p.nom a")[i]["href"]
          wine.url = urlProd
          p wine.url
          image = content.css("div.img a")[i]["id"]
          image = image[image.index("_")+1..-1]
          wine.saq_code = image
          p wine.saq_code
          wine.photo_url = "http://s7d9.scene7.com/is/image/SAQ/" + image.to_s + "-1"
          p wine.photo_url

          description = content.css("p.desc")[i].text.strip
          type = description[0..description.index("\r")-1]
          wine.colour = type
          p wine.colour

          country = description[description.index("\n")..description.index(",")-1].gsub("\n", "").gsub("\r", "").gsub(/\u00A0/, "").strip
          wine.country = country
          p wine.country

          volume = description[description.index(",")+2..description.index(",")+10].strip
          wine.volume = volume
          p wine.volume

          price = content.css("td.price a")[i].text
          p price
          price2 = price[1..-1].gsub(",",".").gsub(/\u00A0/, "").to_f
          wine.price = price2
          p wine.price

          wine.save!
          puts "--------------------"
        end
      end

    end

  end

  puts "Scraping complete!"
end

