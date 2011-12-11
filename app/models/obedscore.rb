class Obedscore < ActiveRecord::Base
  belongs_to :dog
  belongs_to :show
end