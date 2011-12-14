class Dog < ActiveRecord::Base
  attr_accessible :akc_id, :akc_name, :owner, :breed
  validates :akc_name, :presence => true
  validates :akc_id, :presence => true,
                     :uniqueness => true
  has_many :obedscores
  has_many :shows, :through => :obedscores
  
   #
   # Search by column using like
   #
   def self.search_by(column_name, column_value, page)
     search_type = "lower(#{column_name}) LIKE ?"
     search_value = "%" + column_value.downcase + "%"
     paginate(:page=>page, :conditions => [search_type, search_value])
   end
   
  def self.search(type, search, page)
    #search_type = "lower(breed) LIKE ?"
    #search_value = "%" + search.downcase + "%"
    #paginate(:page=>page, :conditions => [search_type, search_value])
    if (type == 'name')
      search_by('akc_name', search, page)
    elsif (type == 'breed')
      search_by('breed', search, page)
    elsif (type == 'number')
      search_by('akc_id', search, page)
    end
  end
end
