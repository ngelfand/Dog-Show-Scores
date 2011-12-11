class DogsController < ApplicationController
  def index
    @title = 'All dogs'
    @dogs = Dog.paginate(:page=>params[:page])
  end
  
  def show
    @dog = Dog.find_by_akc_id(params[:id])
    @title = "Dog #{@dog.akc_id}"
    # get all the shows this dog was in
    @show_results = Obedscore.find_all_by_dog_id(@dog.id, :include => :show)
    @show_results = @show_results
  end
end
