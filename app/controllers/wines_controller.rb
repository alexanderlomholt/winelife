require 'open-uri'
require 'nokogiri'

class WinesController < ApplicationController
  def search

    @wines = [] # start with an empty array

    # declare user input variables
    red = params["red"]
    white = params["white"]
    rose = params["rose"]
    meat = params["meat"]
    fish = params["fish"]
    cheese = params["cheese"]
    budget_1 = params["budget_1"]
    budget_2 = params["budget_2"]
    budget_3 = params["budget_3"]

    query = Wine.all

    # select wines by colour
    wines_match_colour_criteria = if (red && white && rose) || (!red && !white && !rose) # if user checks all boxes or none, it means that wine colour doesn`t matter
       ['Red wine', 'White wine', 'Rosé']
    else
      arr = []

      arr << 'Red wine' if red
      arr << 'White wine' if white
      arr << 'Rosé' if rose

      arr
    end

    query = query.where(colour: wines_match_colour_criteria)
    # select wines by meal pairing
    # if (!meat && !fish && !cheese)
    #   wines_match_meal = Wine.all
    # else
      query = query.meat if meat
      query = query.fish if fish
      query = query.cheese if cheese
      # meat_array = meat ? Wine.meat : Wine.all
      # fish_array = fish ? Wine.fish : Wine.all
      # cheese_array = cheese ? Wine.cheese : Wine.all
      # wines_match_meal = meat_array & fish_array & cheese_array
    # end

    # filter wines by budget
    if (budget_1 && budget_2 && budget_3) || (!budget_1 && !budget_2 && !budget_3) # if user checks all boxes or none, it means that price doesn`t matter
      # wines_match_budget = Wine.all
    else
      wines_match_budget = []
      wines_match_budget << 'price <= 15' if budget_1
      wines_match_budget << '(price > 15 AND price <= 25)' if budget_2
      wines_match_budget << 'price > 25' if budget_3

      query = query.where(wines_match_budget.join(' OR '))
      # wines_match_budget += Wine.budget_1 if budget_1
      # wines_match_budget += Wine.budget_2 if budget_2
      # wines_match_budget += Wine.budget_3 if budget_3
    end

    # intersection of all search criteria
    # wines = wines_match_colour & wines_match_meal & wines_match_budget

    # order wines by rating
    # wines.sort_by! { |wine| -wine.rating }
    query = query.order('rating desc')

    # select only 6 best-rated wines available at nearest SAQ
    @wines = []
    @wine_availability = []

    # detect nearest SAQ outlet
    store_id = Store.near(location.coordinates, 20).first.store_identifier
    puts "store <detected>  </detected>"

    puts "finished building query"
    # CHECK FOR WINE AVAILABILITY AT NEAREST SAQ OUTLET
    starting_time = Time.now
    query.each do |elt|
      product_id = elt.saq_code
      url = "https://www.saq.com/webapp/wcs/stores/servlet/SAQAjaxInventoryInStoreView?catalogId=50000&langId=-1&storeId=20002&productId=#{product_id}&storeInventoryId=#{store_id}"
      html_doc = Nokogiri::HTML(open(url).read)

      content = html_doc.at_css('div:first-of-type').text.strip
      if content[-1] =~ /[0-9]/
        puts "Wine is available"
        @wine_availability << content.scan(/[0-9]+/).first.to_i
        @wines << elt
      else
        puts "Wine is unavailable"
      end
      p Store.where(store_identifier: store_id)
      p elapsed_time = Time.now - starting_time
      break if @wines.count == 6 || (@wines.count >= 2 && elapsed_time > 10.00) || (@wines.count >= 1 && elapsed_time > 15.00) || elapsed_time > 20.00
    end

    unless @wines.empty?
      render :results
    else
      render :no_results
    end
  end

  def results
  end

  def no_results
  end

  def show
    @wine = Wine.find(params[:id])
  end

  private

  def location
    @location ||= if Rails.env.test? || Rails.env.development?
      Geocoder.search("Montreal").first
    else
      request.location
    end
  end
end
