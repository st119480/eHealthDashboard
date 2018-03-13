class BloodType < ApplicationRecord
  has_and_belongs_to_many :patient
end
