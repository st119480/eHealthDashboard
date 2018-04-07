class AddQualificationToNurse < ActiveRecord::Migration[5.1]
  def change
    add_column :nurses, :qualification, :string
  end
end
