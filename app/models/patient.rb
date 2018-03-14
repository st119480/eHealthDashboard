class Patient < ActiveRecord::Base
  #attr_accessor :blood_type_id
  acts_as :user
  has_one :blood_type
  belongs_to :user
  validates :blood_type_id, :presence => true
  #validates :user_id, :presence => true
end
