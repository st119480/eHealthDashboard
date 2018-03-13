class Patient < User
  attr_accessor :blood_type_id
  has_one :blood_type
  validates :blood_type_id, :presence => true
end
