class Show < ActiveRecord::Base
  attr_accessible :show_id, :name, :state, :date
  validates :name, :presence => true
  validates :show_id, :presence => true,
                        :uniqueness => true
end
