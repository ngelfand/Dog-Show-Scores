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
    # get all rally shows this dog was in
    @ralshow_results = Ralscore.find_all_by_dog_id(@dog.id, :include => :ralshow, 
                                                  :order=>'ralshows.date ASC')
       
    # calculate various interesting statistics for obedience                                           
    openb_sum = 0
    openb_count = 0
    utilb_sum = 0
    utilb_count = 0
    @num_200s = 0
    @show_results.each do |result|
      if result.classname == "Open B"
        openb_sum += result.score
        openb_count += 1
      elsif result.classname == "Utility B"
        utilb_sum += result.score
        utilb_count += 1
      end
      if result.score == 200
        @num_200s += 1
      end
    end
    
    if openb_count > 0
      @openb_average = openb_sum / openb_count
      @openb_average = @openb_average.round(1)
    else
      @openb_average = 0
    end
    
    if utilb_count > 0
      @utilb_average = utilb_sum / utilb_count
      @utilb_average = @utilb_average.round(1)
    else
      @utilb_average = 0
    end
    
    
  end  
  
  def search
    @title = 'Dog search'
    @dogs = Dog.search(params[:searchtype], params[:search], params[:page])
  end
end
