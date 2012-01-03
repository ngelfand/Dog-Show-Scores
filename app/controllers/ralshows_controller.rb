class RalshowsController < ApplicationController
  def index
    @title = "All Rally Shows"
    @ralshows = Ralshow.paginate(:page=>params[:page], :order=>'date DESC')
  end
  
  def show
    @show = Ralshow.find_by_show_id(params[:id])
    @title = "#{@show.name} Rally"
    @classes = Ralclass.find_all_by_ralshow_id(@show.id, :include => :judge)
    @scores = Ralscore.find_all_by_ralshow_id(@show.id, :include => :dog,
                                             :order => 'classorder asc, placement asc')
  end
  
  def search
    @ralshows = Ralshow.search(params[:searchtype], params[:search], params[:page])
  end
end
