class ShowsController < ApplicationController
  def new
  end

  def show
    @show = Show.find_by_show_id(params[:id])
    @title = "@show.name"
    @classes = Obedclass.find_all_by_show_id(@show.id, :include => :judge)
    @scores = Obedscore.find_all_by_show_id(@show.id, :include => :dog,
                                            :order => 'classname ASC')
  end
  
  def index
    @title = "All Shows"
    @shows = Show.paginate(:page=>params[:page], :order=>'date DESC')
  end
  
end
