class Show < ActiveRecord::Base
  has_many :obedclasses
  has_many :judges, :through => :obedclasses
  has_many :obedscores
  has_many :dogs, :through => :obedscores
  attr_accessible :show_id, :name, :state, :date
  validates :name, :presence => true
  validates :show_id, :presence => true,
                        :uniqueness => true
                        
                                      
   #############################################################
   # Search shows by name, date, city, or state using LIKE
   #############################################################
   def self.search(type, search, page)
       search_type = "lower(#{type}) LIKE ?"
       search_value = "%" + search.downcase + "%"
       paginate(:page=>page, :conditions => [search_type, search_value],
                :order=> 'date ASC')
    end                    
end
