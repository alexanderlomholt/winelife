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

    # select wines by colour
    if (red && white && rose) || (!red && !white && !rose) # if user checks all boxes or none, it means that wine colour doesn`t matter
      wines_match_colour = Wine.all
    else
      wines_match_colour = []
      wines_match_colour += Wine.red if red
      wines_match_colour += Wine.white if white
      wines_match_colour += Wine.rose if rose
    end

    # select wines by meal pairing
    if (!meat && !fish && !cheese)
      wines_match_meal = Wine.all
    else
      meat_array = meat ? Wine.meat : Wine.all
      fish_array = fish ? Wine.fish : Wine.all
      cheese_array = cheese ? Wine.cheese : Wine.all
      wines_match_meal = meat_array & fish_array & cheese_array
    end

    # filter wines by budget
    if (budget_1 && budget_2 && budget_3) || (!budget_1 && !budget_2 && !budget_3) # if user checks all boxes or none, it means that price doesn`t matter
      wines_match_budget = Wine.all
    else
      wines_match_budget = []
      wines_match_budget += Wine.budget_1 if budget_1
      wines_match_budget += Wine.budget_2 if budget_2
      wines_match_budget += Wine.budget_3 if budget_3
    end

    # intersection of all search criteria
    @wines = wines_match_colour & wines_match_meal & wines_match_budget

    # order wines by rating
    @wines.sort_by! { |wine| -wine.rating }

    # select only 6 best-rated wines
    @wines = @wines.first(6)
    @wines.each { |elt| puts elt.name }
    puts "-----------"

    # TODO: DETECT NEAREST SAQ STORE ID

    # delete unavailable wines at array
    @wines.each_with_index do |elt, i|
      # ==== CHECK FOR WINE AVAILABILITY AT SPECIFIC SAQ OUTLET ====
      store_id = 23015
      product_id = elt.saq_code
      url = "https://www.saq.com/webapp/wcs/stores/servlet/SAQAjaxInventoryInStoreView?catalogId=50000&langId=-1&storeId=20002&productId=#{product_id}&storeInventoryId=#{store_id}"

      html_doc = Nokogiri::HTML(open(url).read)

      content = html_doc.at_css('div:first-of-type')
      # p content.text.strip
      if content.text.strip[-1] =~ /[0-9]/
        # puts "Wine is available"
      else
        # puts "wine not available"
        @wines.delete_at(i)
      end
      # =============================================================
    end

    @wines.each { |elt| p elt }


    # render :results
  end

  def results
  end

  def show
  end
end
