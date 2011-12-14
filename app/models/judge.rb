class Judge < ActiveRecord::Base
  has_many :obedclasses
  has_many :shows, :through => :obedclasses
  attr_accessible :judge_id, :name, :address, :city, :state, :zip, :country
  validates :name, :presence => true
  validates :judge_id, :presence => true,
                       :uniqueness => true
    
  #####################################################################                    
  # Get an array of obedience shows and an array with classes that this
  # judge judged. This returns two arrays, which is very non-ruby and I
  # should probably do some kind of weird class re-writing thing, but I
  # don't know how. I am sorry.
  ##################################################################### 
  def showswithclasses
    shows = self.shows
    classes = self.obedclasses
    result_shows = Hash.new
    result_classes = Hash.new
    i = 0
    shows.each do |show|
      if !result_shows.has_key?(show.show_id)
        result_shows[show.show_id] = show
        result_classes[show.show_id] = []
      end
      result_classes[show.show_id].push(classes[i].classname)
      i += 1
    end
    return result_shows.values, result_classes.values
  end
  
  
  ##################################################################### 
  # Search by judge name using LIKE
  ##################################################################### 
  def self.search(column_value, page)
     search_type = "lower(name) LIKE ?"
     search_value = "%" + column_value.downcase + "%"
     paginate(:page=>page, :conditions => [search_type, search_value])
   end
end
