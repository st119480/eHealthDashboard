class DoctorController < ApplicationController
  before_action :authenticate_user!
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  def index
    if current_user.role_id == 1 || current_user.role_id == 4
      @doctors = Doctor.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      render :show
    end
  end

  def show
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      @doctor = Doctor.find(params[:id])
    end
  end

  def new
    if current_user.role_id == 1 || current_user.role_id == 4
      @doctor = Doctor.new
      #@user.build_doctor
    else
      render :show
    end
  end

  def create
    @doctor = Doctor.new(doctor_params)
    @doctor.user_id = @doctor.id
    # @doctor = current_user.doctors.build(doctor_params)
    if @doctor.save
      redirect_to doctor_index_path, notice: "Doctor created successfully !!! "
    else
      redirect_to doctor_index_path, notice: "Doctor was not created !!! "
    end
  end

  def edit
    if current_user.role_id == 1 || current_user.role_id == 4
      @doctor = Doctor.find(params[:id])
    else
      redirect_to user_index_path
    end
  end

  def update
    if current_user.role_id == 1 || current_user.role_id == 4
      @doctor = Doctor.find(params[:id])
      if @doctor.update(doctor_params)
        redirect_to doctor_index_path, notice: "Doctor was edited successfully !!! "
      else
        render :edit, notice: "Doctor edit unsuccessful !!! "
      end
    end
  end

  def destroy
    if current_user.role_id == 1 || current_user.role_id == 4
      @doctor = Doctor.find(params[:id])
      @doctor.destroy
      respond_to do |format|
        format.html {redirect_to doctor_index_path, notice: 'Doctor was successfully deleted !!!'}
        format.json {head :no_content}
      end
    else
      redirect_to doctor_index_path
    end
  end

  private
  def set_doctor
    #begin
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender,
                                   :contact, :username, :province, :city_village, :address_line_1, :role_id, :specialty_id,
                                   :user_id, :license_num, :qualification)
  end

  def sort_column
    Doctor.joins(doctors: :users).column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
