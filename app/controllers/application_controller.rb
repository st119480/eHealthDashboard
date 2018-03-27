class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :get_appointments, :get_patients, :get_tests

  def after_sign_in_path_for(resource)
    user_path(current_user.id)
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

  def get_patients
    if current_user.role_id == 2
      usr_id = @user.id
    elsif
      usr_id = @doctor.user_id
    end
    @my_patients = Appointment.joins(:patient, :doctor).where('doctors.user_id'=>usr_id).order(updated_at: :desc)
  end

  def get_tests
    if current_user.role_id == 1 || current_user.role_id == 2
      usr_id = @patient.user_id
    elsif
      usr_id = @user.id
    end
    @my_tests = Test.joins(:patient).where('patients.user_id'=>usr_id).order(updated_at: :desc)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender, :contact, :username, :province, :city_village, :address_line_1, :role_id) }

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :password, :password_confirmation, :current_password,:dob,  :gender, :province, :city_village, :address_line_1, :contact ) }
  end
end
