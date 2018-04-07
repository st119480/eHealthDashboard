class InsertNurseRoleIntoRoleTable < ActiveRecord::Migration[5.1]
  def up
    execute("insert into roles(id, description, created_at, updated_at) values(4,'Nurse', current_timestamp,current_timestamp);")
  end
end
