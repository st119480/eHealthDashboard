class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.references :blood_type, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
