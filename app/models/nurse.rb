class Nurse < ApplicationRecord
  acts_as :user
  belongs_to :user
end
