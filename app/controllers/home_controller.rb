class HomeController < ApplicationController
  def index
    @categories = Category.where(enabled: true).order(:order)
  end
end
