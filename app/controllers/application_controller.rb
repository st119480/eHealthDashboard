class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :get_appointments, :get_patients, :get_tests, :get_tests_json, :get_appointments_for_nurse

  def after_sign_in_path_for(resource)
    if current_user.role_id == 1
      dashboard_path
    else
      user_path(current_user.id)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def get_appointments
    if current_user.role_id == 3
      usr_id = @user.id
    else
      usr_id = @patient.user_id
    end
    @appointments = Appointment.joins(:patient, :doctor).where('patients.user_id'=>usr_id).order(updated_at: :desc)
  end

  def get_appointments_for_nurse
    @appointments = Appointment.joins(:patient, :doctor).where('appointment_date >= current_date').order(appointment_date: :asc)
  end


  def get_patients
    if current_user.role_id == 2
      usr_id = @user.id
    elsif
      usr_id = @doctor.user_id
    end
    @my_patients = Appointment.joins(:patient, :doctor).where('doctors.user_id'=>usr_id).order(updated_at: :desc)
  end

  def get_tests
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      usr_id = @patient.user_id
    elsif
      usr_id = @user.id
    end
    @my_tests = Test.joins(:patient).where('patients.user_id'=>usr_id).order(test_date: :desc)
  end


  def get_tests_json
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      usr_id = @patient.user_id
    elsif
      usr_id = @user.id
    end
    @my_tests_json = Test.joins(:patient).where('patients.user_id'=>usr_id).order(test_date: :desc).to_json
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender, :contact, :username, :province, :city_village, :address_line_1, :role_id) }

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :password, :password_confirmation, :current_password,:dob,  :gender, :province, :city_village, :address_line_1, :contact ) }
  end
end
