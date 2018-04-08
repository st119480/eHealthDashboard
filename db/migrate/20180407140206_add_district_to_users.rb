class AddDistrictToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :district, :string
  end
end
