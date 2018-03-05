
task :wine_scraper => :environment do
  require "nokogiri"
  require "open-uri"
  # require "http"

  # url array
  urls = ["https://www.saq.com/webapp/wcs/stores/servlet/AjaxProduitSearchResultView?facetSelectionCommandName=SearchDisplay&searchType=&originalSearchTerm=*&orderBy=1&categoryIdentifier=06&showOnly=product&langId=-1&beginIndex=0&metaData=&pageSize=4500&catalogId=50000&searchTerm=*&pageView=grid&facet=&categoryId=39919&storeId=20002&orderByType=2&filterFacet=",
          "https://www.saq.com/webapp/wcs/stores/servlet/AjaxProduitSearchResultView?facetSelectionCommandName=SearchDisplay&searchType=&originalSearchTerm=*&orderBy=1&categoryIdentifier=06&showOnly=product&langId=-1&beginIndex=4500&metaData=&pageSize=4500&catalogId=50000&searchTerm=*&pageView=grid&facet=&categoryId=39919&storeId=20002&orderByType=2&filterFacet="]

  # boucle pour passer à travers chacun des fichiers html
  urls.each do |url|

    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    page.css("div.wrapper-middle-rech").map do |content|

      (0..3).each do |i|
        wine = Wine.new

        #il arrive que certains "emplacements" soient vides; on les saute avec la condition ci-dessous

        if content.css("p.nom a")[i] != nil
          name = content.css("td.price .hors-ecran")[i].text.strip.split(",")[0]
          wine.name = name #on extrait le nom du produit
          p wine.name #affichage aux fins de vérification
          #dans certains noms de produits, il y a une année généralement placée à la fin; si c'est le cas, on va la chercher pour nous donner l'année du produit (millésime)
          if name[-4..-3] == "20" || name[-4..-3] == "19"
            year = name[-4..-1]
            wine.year = year
          end
          p wine.year

          #pour vérifier ultérieurement si notre extraction est conforme à la réalité, il est toujours bon de copier l'url de la page d'un produit, ainsi que l'url de l'image correspondant au produit
          urlProd = content.css("p.nom a")[i]["href"]
          wine.url = urlProd
          p wine.url
          image = content.css("div.img a")[i]["id"]
          image = image[image.index("_")+1..-1]
          wine.saq_code = image
          p wine.saq_code
          wine.photo_url = "http://s7d9.scene7.com/is/image/SAQ/" + image.to_s + "-1"
          p wine.photo_url

          #on va ensuite chercher le type de produit dont il est question ("vin rouge", "vodka", "bière", etc.)
          description = content.css("p.desc")[i].text.strip
          type = description[0..description.index("\r")-1]
          wine.colour = type
          p wine.colour

          country = description[description.index("\n")..description.index(",")-1].gsub("\n", "").gsub("\r", "").gsub(/\u00A0/, "").strip
          wine.country = country
          p wine.country

          #le volume est une information très importante, puisqu'elle nous permet de comparer des produits réellement identiques
          volume = description[description.index(",")+2..description.index(",")+10].strip
          wine.volume = volume
          p wine.volume

          #on va enfin chercher le prix du produit
          #il est d'abord sous forme d'une chaîne de caractères
          prix = content.css("td.price a")[i].text
          p prix
          #on traduit ensuite la chaînes de caractères en un nombre afin de faire des calculs plus tard
          prix2 = prix[1..-1].gsub(",",".").gsub(/\u00A0/, "").to_f
          wine.price = prix2
          p wine.price

          wine.save!
        end
      end

    end

  end

  puts "Added " + Wine.count.to_s + " wines to database."

end

