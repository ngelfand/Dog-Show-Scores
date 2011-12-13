class Dog < ActiveRecord::Base
  attr_accessible :akc_id, :akc_name, :owner, :breed
  validates :akc_name, :presence => true
  validates :akc_id, :presence => true,
                     :uniqueness => true
  has_many :obedscores
  has_many :shows, :through => :obedscores
  
  #
  # Search by the AKC registered name, or part of it
  #
  def self.search_name(condition)
    search_condition = "%" + condition.downcase + "%"
    find(:all, :conditions => ['lower(akc_name) LIKE ?', search_condition])
  end
  
  #
  # Search by AKC registration
  #
  def self.search_akc_id(condition)
    search_condition = "%" + condition + "%"
    find(:all, :conditions => ['akc_id LIKE ?', search_condition])
  end
  
  #
  # Search by breed name
  #
  def self.search_breed(condition)
    search_condition = "%" + condition + "%"
    find(:all, :conditions => ['breed LIKE ?', search_condition])
  end
end
