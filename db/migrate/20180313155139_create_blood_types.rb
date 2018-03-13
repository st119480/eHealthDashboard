class CreateBloodTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :blood_types do |t|
      t.string :blood_group_rh_type

      t.timestamps
    end
  end
end
