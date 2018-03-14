class CreateSpecialties < ActiveRecord::Migration[5.1]
  def change
    create_table :specialties do |t|
      t.string :description

      t.timestamps
    end
  end
end
