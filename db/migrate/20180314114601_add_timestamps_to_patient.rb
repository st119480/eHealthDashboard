class AddTimestampsToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :created_at, :string
    add_column :patients, :updated_at, :string
  end
end
