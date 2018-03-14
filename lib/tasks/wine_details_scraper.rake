task :wine_details_scraper => :environment do
  require "nokogiri"
  require "open-uri"

  puts "Please enter interval between each request (in seconds)"
  interval = STDIN.gets.chomp.to_f

  total = Wine.where(variety: nil).count
  counter = 1
  Wine.where(variety: nil).each do |wine|

    puts "Fetching information for #{wine.name}, code #{wine.saq_code}"

    url = wine.url
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    page.css("h3.tasting-title+p").each do |elt|
      p_content = elt.text.strip
      if p_content[0..7] == "Between:"
        puts "Serving temp"
        p wine.serving_temperature = p_content.remove("\r\n         ").remove(":").remove("Between").gsub("and", "-").strip
      elsif p_content.length > 60
        puts "Tasting note"
        p wine.tasting_note = p_content
      end
    end

    # unless page.at_css(".description p:nth-of-type(1)").nil?
    #   if page.at_css(".description p:nth-of-type(1)").text.strip[0..13] == "Vintage tasted"
    #     p wine.tasting_note = page.at_css(".description p:nth-of-type(2)").text.strip
    #   else
    #     p wine.tasting_note = page.at_css(".description p:nth-of-type(1)").text.strip
    #   end
    #   page.css(".description p").each do |elt|
    #     p wine.serving_temperature = elt.text.strip.remove("\r\n         ").remove(":").capitalize if elt.text.strip[0..7] == "Between:"
    #   end
    # end

    page.css("#details > ul:nth-of-type(3) > li").each do |elt|
      if elt.at_css(".left").text.strip == "Degree of alcohol"
        puts "Degree of alcohol"
        p wine.alcohol_percent = elt.at_css(".right").text.strip
      end
      if elt.at_css(".left").text.strip == "Grape variety(ies)"
        puts "Variety"
        variety_array = []
        elt.css(".right td.col1").each { |variety| variety_array << variety.text.strip }
        p wine.variety = variety_array.join(", ")
      end
    end

    wine.save!
    puts "---------- #{counter}/#{total} ----------"
    sleep interval;
    counter += 1
  end

  puts "Scraping complete!"
end
