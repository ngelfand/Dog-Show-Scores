class Show < ActiveRecord::Base
  has_many :obedclasses
  has_many :judges, :through => :obedclasses
  attr_accessible :show_id, :name, :state, :date
  validates :name, :presence => true
  validates :show_id, :presence => true,
                        :uniqueness => true
end
