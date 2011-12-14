class DogsController < ApplicationController
  def index
    @title = 'All dogs'
    @dogs = Dog.paginate(:page=>params[:page])
  end
  
  def show
    @dog = Dog.find_by_akc_id(params[:id])
    @title = "Dog #{@dog.akc_id}"
    # get all the shows this dog was in
    @show_results = Obedscore.find_all_by_dog_id(@dog.id, :include => :show, 
                                                :order=>'shows.date ASC')
    @show_results = @show_results
  end  
  
  def search
    @title = 'Dog search'
    @dogs = Dog.search(params[:searchtype], params[:search], params[:page])
  end
end
