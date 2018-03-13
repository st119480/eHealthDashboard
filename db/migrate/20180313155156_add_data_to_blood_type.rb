class AddDataToBloodType < ActiveRecord::Migration[5.1]
  def change
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(1, 'A +ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(2, 'A -ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(3, 'B +ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(4, 'B -ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(5, 'O +ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(6, 'O -ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(7, 'AB +ve', current_timestamp,current_timestamp);")
    execute("insert into blood_types(id, blood_group_rh_type, created_at, updated_at) values(8, 'AB -ve', current_timestamp,current_timestamp);")
  end
end
