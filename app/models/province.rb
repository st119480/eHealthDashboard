class Province < ApplicationRecord
  has_many :districts
  has_many :users
end
