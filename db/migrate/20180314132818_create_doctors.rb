class CreateDoctors < ActiveRecord::Migration[5.1]
  def change
    create_table :doctors do |t|
      t.string :license_num , null: false, default: ""
      t.string :qualification, default: ""
      t.references :user, foreign_key: true
      t.references :specialty, foreign_key: true

      t.timestamps
    end
  end
end
