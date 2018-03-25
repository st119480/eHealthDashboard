class Test < ApplicationRecord
  belongs_to :patient
  attr_accessor :patient_id
end
