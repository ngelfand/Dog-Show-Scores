class Dog < ActiveRecord::Base
  attr_accessible :akc_id, :akc_name, :owner, :breed
  validates :akc_name, :presence => true
  validates :akc_id, :presence => true,
                     :uniqueness => true
end
