class District < ApplicationRecord
  belongs_to :province
  has_many :users

  def self.get_district(province_id)
    if search
      where('province_id = ?', "%#{province_id}%")
    else
      all
    end
  end

end
