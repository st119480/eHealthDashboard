class RemoveUpdatedDateFromPatients < ActiveRecord::Migration[5.1]
  def change
    remove_column :patients, :updated_date, :string
  end
end
