class ShowsController < ApplicationController
  def new
  end

  def show
    @show = Show.find_by_show_id(params[:id])
  end
  
  def list
  end
  
end
