class InsertDataIntoRole < ActiveRecord::Migration[5.1]
  def up
    execute("insert into roles(id, description, created_at, updated_at) values(1,'Administrator', current_timestamp,current_timestamp);")
    execute("insert into roles(id, description, created_at, updated_at) values(2,'Doctor', current_timestamp,current_timestamp);")
    execute("insert into roles(id, description, created_at, updated_at) values(3,'Patient', current_timestamp,current_timestamp);")
  end
end
