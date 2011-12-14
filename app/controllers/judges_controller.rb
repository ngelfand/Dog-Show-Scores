class JudgesController < ApplicationController
  def new
  end

  def index
    @title = "All Judges"
    @judges = Judge.paginate(:page=>params[:page], :order=>'judge_id ASC')
  end
  
  def show
    @judge = Judge.find_by_judge_id(params[:id])
    @shows, @classes = @judge.showswithclasses
    @title = @judge.name
  end

  def search
    @title = 'Judge search'
    @judges = Judge.search(params[:search], params[:page])
  end
  
  def add
  end

  def delete
  end

end
