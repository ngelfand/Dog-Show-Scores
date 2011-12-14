class Dog < ActiveRecord::Base
  attr_accessible :akc_id, :akc_name, :owner, :breed
  validates :akc_name, :presence => true
  validates :akc_id, :presence => true,
                     :uniqueness => true
  has_many :obedscores
  has_many :shows, :through => :obedscores
   
  def self.search(type, search, page)
    search_type = "lower(#{type}) LIKE ?"
    search_value = "%" + search.downcase + "%"
    paginate(:page=>page, :conditions => [search_type, search_value])
  end
end
