class AddActableTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.integer :actable_id
      t.string  :actable_type
    end
  end
end
