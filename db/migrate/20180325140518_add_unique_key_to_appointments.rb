class AddUniqueKeyToAppointments < ActiveRecord::Migration[5.1]
  def change
    add_index :appointments, [:patient_id, :doctor_id, :appointment_date], unique: true,
              :name => 'index_appointments_on_patient_id_and_doctor_id_and_appt_date'
  end
end
