class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.text :prev_diagnosis
      t.text :prev_medication
      t.text :ongoing_medication
      t.integer :pulse_rate
      t.float :body_temperature
      t.integer :respiratory_rate
      t.integer :bp_systolic
      t.integer :bp_diastolic
      t.integer :blood_oxygen_saturation
      t.integer :blood_sugar_pp
      t.integer :blood_sugar_fasting
      t.integer :height
      t.float :weight
      t.float :bmi
      t.date :test_date
      t.text :recommendation
      t.references :patient, foreign_key: true
      t.timestamps
    end
  end
end
