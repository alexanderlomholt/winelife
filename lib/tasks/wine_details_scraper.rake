task :wine_details_scraper => :environment do
  require "nokogiri"
  require "open-uri"

  puts "Please enter interval between each request (in seconds)"
  interval = STDIN.gets.chomp.to_f

  Wine.first(10).each do |wine|

    url = wine.url
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    unless page.at_css(".description p:nth-of-type(1)").nil?
      if page.at_css(".description p:nth-of-type(1)").text.strip[0..13] == "Vintage tasted"
        p wine.tasting_note = page.at_css(".description p:nth-of-type(2)").text.strip
        p wine.serving_temperature = page.at_css(".description p:nth-of-type(3)").text.strip.remove("\r\n         ").remove(":").capitalize
      else
        p wine.tasting_note = page.at_css(".description p:nth-of-type(1)").text.strip
        p wine.serving_temperature = page.at_css(".description p:nth-of-type(2)").text.strip.remove("\r\n         ").remove(":").capitalize
      end
    end

    page.css("#details > ul:nth-of-type(3) > li").each do |elt|
      if elt.at_css(".left").text.strip == "Degree of alcohol"
        p wine.alcohol_percent = elt.at_css(".right").text.strip
      end
    end

    wine.save!
    puts "--------------------"
    sleep interval;
  end

  puts "Scraping complete!"
end

