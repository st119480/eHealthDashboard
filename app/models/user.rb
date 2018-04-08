class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  actable
  devise :database_authenticatable , :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :role
  has_one :patient, dependent: :destroy
  has_one :doctor, dependent: :destroy
  has_one :admin, dependent: :destroy
  has_one :nurse, dependent: :destroy
  belongs_to :province
  belongs_to :district
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :dob, :presence => true
  validates :role_id, :presence => true


  def self.search(search)
    if search
      where('username ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      all
    end
  end

end
