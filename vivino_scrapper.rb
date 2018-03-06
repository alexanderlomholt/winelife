require 'open-uri'
require 'nokogiri'

def get_food_pairings(html_element) 
	# returns {meat: 0, fish: 1, cheese: 1}
	pairings_hash = {meat: 0, fish: 0, cheese: 0}
	p html_element
end

Wine.all.each do |wine|
	wine_name = "Ninquen+2014"
	url = "https://www.vivino.com/search/wines?q=#{wine_name}"

	html_file = open(url).read
	html_doc = Nokogiri::HTML(html_file)
	wine_card = html_doc.search('.card').first
	
	begin
		rating = wine_card.search('.average__number').first.text.gsub(",",".").to_f	
		reviews_number = wine_card.search('.average__stars .text-micro').text.gsub(" ratings", "")

		wine_url = wine_card.search('.wine-card__name > a').attribute("href")

		puts wine_complete_url = "https://www.vivino.com" + wine_url

		html_file = open(wine_complete_url).read
		html_doc = Nokogiri::HTML(html_file)

		pairings_html = html_doc.search('[data-item-type=food-pairing]')

		food_pairings = get_food_pairings(pairings_html)

		# wine.update(rating: , reviews_number: , food_pairing: )
		# wine.update()
	rescue NotMethodError => e
		puts "Error #{e}"
	end
end

