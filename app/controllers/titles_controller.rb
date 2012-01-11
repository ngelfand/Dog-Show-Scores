class TitlesController < ApplicationController

  def index
    @title = "Breed and title search"
    @titles = ["CD", "CDX", "UD", "UDX", "OTCH", "RN", "RA", "RE", "RAE"]
  end
  
  def search
    @title = "Search Results"
    @dogs = Dog.find_by_breed_and_title(params[:breed], params[:title])
  end
  
  def show
  end
  
end
