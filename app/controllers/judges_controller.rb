class JudgesController < ApplicationController
  def new
  end

  def index
    @title = "All Judges"
    @judges = Judge.paginate(:page=>params[:page])
  end
  
  def show
    @judge = Judge.find_by_judge_id(params[:id])
    @title = @judge.name
  end

  def add
  end

  def delete
  end

end
