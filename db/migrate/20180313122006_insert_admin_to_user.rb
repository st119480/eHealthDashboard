class InsertAdminToUser < ActiveRecord::Migration[5.1]
  def self.up
    User.create(:username => "superman", :role_id => 1, :first_name => "Super", :last_name => "Admin",
                :email => "superman@ehealth.com", :password => "admin123", :dob => '1990-02-02')
  end
  def self.down
    User.delete_all(:r => "superman")
  end
end
