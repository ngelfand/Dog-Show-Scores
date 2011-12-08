class JudgesController < ApplicationController
  def new
  end

  def show
    @judge = Judge.find_by_judge_id(params[:id])
  end

  def add
  end

  def delete
  end

end
