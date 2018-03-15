class PagesController < ApplicationController
  # need this for user signed in redirect in routes.rb
  # skip_before_action :authenticate_user!, only: [:home]

  def home
  end

end
