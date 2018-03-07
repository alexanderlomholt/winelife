require 'open-uri'
require 'nokogiri'

class WinesController < ApplicationController
  def search
    # run super magic algorithm

    # ==== CHECK FOR WINE AVAILABILITY AT SPECIFIC SAQ OUTLET ====
    store_id = 23015
    product_id = 928853
    url = "https://www.saq.com/webapp/wcs/stores/servlet/SAQAjaxInventoryInStoreView?catalogId=50000&langId=-1&storeId=20002&productId=#{product_id}&storeInventoryId=#{store_id}"

    html_doc = Nokogiri::HTML(open(url).read)

    content = html_doc.at_css('div:first-of-type')
    p content.text.strip
    if content.text.strip[-1] =~ /[0-9]/
      puts "Wine is available"
    else
      puts "wine not available"
    end
    # =============================================================

    # render :results
  end

  def results
  end

  def show
  end
end
