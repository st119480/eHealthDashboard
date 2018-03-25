class Doctor < ApplicationRecord
  acts_as :user
  has_one :specialty
  belongs_to :user
  has_many :appointments, dependent: :destroy
  has_many :patients, through: :appointments

  #validates :user_id, :presence => true
  validates :license_num, :presence => true
  #validates :specialty_id, :presence => true
end
