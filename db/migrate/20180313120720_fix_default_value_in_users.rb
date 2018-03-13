class FixDefaultValueInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :contact, ""
    change_column_default :users, :province, ""
    change_column_default :users, :city_village, ""
    change_column_default :users, :address_line_1, ""
  end
end
