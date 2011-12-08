class Judge < ActiveRecord::Base
  attr_accessible :judge_id, :name, :address, :city, :state, :zip, :country
  validates :name, :presence => true
  validates :judge_id, :presence => true,
                       :uniqueness => true
end
