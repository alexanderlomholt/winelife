require 'open-uri'
require 'nokogiri'

def get_food_pairs(html_element)
	# returns {meat: false, fish: true, cheese: true}
	pairs = { with_meat: false, with_fish: false, with_cheese: false }

	# TODO: finish arrays
	meats =  ["beef", "lamb", "poultry", "spice food", "veal", "cured meat", "game (deer, venison)", "pork"]
	fish =  ["rich fish (salmon, tuna etc)", "pasta", "shellfish", "vegetarian"]
	cheese =  ["sweet desserts", "aperitif", "appetizers and snacks", "blue cheese", "fruity desserts", "goat cheese", "lean fish", "mature and hard cheese", "mild and soft cheese", "mushrooms"]

	html_element.each do |pairing|
		key = pairing.text.downcase.strip

		if meats.include?(key)
			pairs[:with_meat] = true
		elsif fish.include?(key)
			pairs[:with_fish] = true
		elsif cheese.include?(key)
			pairs[:with_cheese] = true
		end
	end
	return pairs
end

task :vivino_scraper => :environment do

	Wine.all.each do |wine|
    p wine_name_normalized = wine.name.gsub(/\s+/, "%20").unicode_normalize(:nfkd).encode('ASCII', replace: '')
		url = "https://www.vivino.com/search/wines?q=#{wine_name_normalized}"

		html_file = open(url).read
		html_doc = Nokogiri::HTML(html_file)
		wine_card = html_doc.search('.card').first

		begin
			rating = wine_card.search('.average__number').first.text.gsub(",",".").to_f
			reviews_number = wine_card.search('.average__stars .text-micro').text.gsub(" ratings", "")

			wine_url = wine_card.search('.wine-card__name > a').attribute("href")

			wine_complete_url = "https://www.vivino.com" + wine_url

			html_file = open(wine_complete_url).read
			html_doc = Nokogiri::HTML(html_file)

			pairs_html = html_doc.search('[data-item-type=food-pairing]')

			pairs = get_food_pairs(pairs_html)

			# refacto; put in methods (if time)
			wine.update(rating: rating, reviews_number: reviews_number, pairs_with_meat: pairs[:with_meat], pairs_with_seafood: pairs[:with_fish], pairs_with_cheese: pairs[:with_cheese] )

		rescue NotMethodError => e
			puts "Error #{e}"
		end
	end
end
