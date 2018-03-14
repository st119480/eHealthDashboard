class RemoveTimestampsFromPatients < ActiveRecord::Migration[5.1]
  def change
    remove_column :patients, :created_at, :string
    remove_column :patients, :updated_at, :string
  end
end
