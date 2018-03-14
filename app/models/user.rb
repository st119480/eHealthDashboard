class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  actable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :role
  has_one :patient, dependent: :destroy
  has_one :doctor, dependent: :destroy
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :dob, :presence => true
  validates :role_id, :presence => true


end
