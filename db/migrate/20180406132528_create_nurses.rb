class CreateNurses < ActiveRecord::Migration[5.1]
  def change
    create_table :nurses do |t|
      t.string :license_num
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
