class CreateDistricts < ActiveRecord::Migration[5.1]
  def change
    create_table :districts do |t|
      t.string :district_name
      t.references :province, foreign_key: true

      t.timestamps
    end
  end
end
