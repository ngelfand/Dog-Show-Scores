class BreedpagesController < ApplicationController
  def collie
    @title = "Collie Page"
    
    if not params[:start_date].nil?
      # find all scores where show is in a given month and dog breed is a smooth or rough collie
      @start_date = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      @end_date = DateTime.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
      @scores = Obedscore.find(:all, :joins => "obedscores inner join shows as s on obedscores.show_id = s.id inner join dogs as d on obedscores.dog_id = d.id",
      :conditions=>["s.date >= ? AND s.date <= ? AND (d.breed LIKE ? or d.breed LIKE ?)", @start_date, @end_date, "%Rough Collie%", "%Smooth Collie%"],
      :order=>'s.date ASC')   
      
      # this is very very very bad but unfortunately I don't have a good way to do it, I need to relate obedscore to obedclass somehow to make 
      # it more efficient
      @totals = []
      @scores.each do |score|
        obedclass = Obedclass.find_by_show_id_and_classname(score.show.id, score.classname)
        @totals.push(obedclass.dogs_in_class)
      end
    end
  end
  
  def yorkshire_terrier
    @title = "Yorkie Page"
    
    if not params[:start_date].nil?
      # find all scores where show is in a given month and dog breed is a smooth or rough collie
      @start_date = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      @end_date = DateTime.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
      @scores = Obedscore.find(:all, :joins => "obedscores inner join shows as s on obedscores.show_id = s.id inner join dogs as d on obedscores.dog_id = d.id",
      :conditions=>["s.date >= ? AND s.date <= ? AND lower(d.breed) LIKE ?", @start_date, @end_date, "%yorkshire terrier%"],
      :order=>'s.date ASC')   
    end
  end
  
end
