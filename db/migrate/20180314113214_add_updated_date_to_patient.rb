class AddUpdatedDateToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :updated_date, :timestamp, :null => false, :default => Time.now
  end
end
