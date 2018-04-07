class PatientController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction


  def index
    if current_user.role_id == 1 || current_user.role_id == 4
      @patients = Patient.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      render :show
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def new
    if current_user.role_id == 1 || current_user.role_id == 4
      @patient = Patient.new
      #@user.build_patient
    else
      render :show
    end
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.user_id = @patient.id
   # @patient = current_user.patients.build(patient_params)
    if @patient.save
      redirect_to patient_index_path, notice: "Patient created successfully !!! "
    else
      redirect_to patient_index_path, notice: "Patient was not created !!! "
    end
  end

  def edit
    if current_user.role_id == 1 || current_user.role_id == 4
      @patient = Patient.find(params[:id])
    else
      redirect_to user_index_path
    end
  end

  def update
    if current_user.role_id == 1 || current_user.role_id == 4
      @patient = Patient.find(params[:id])
      if @patient.update(patient_params)
        redirect_to patient_index_path, notice: "Patient was edited successfully !!! "
      else
        render :edit, notice: "Patient edit unsuccessful !!! "
      end
    end
  end

  def destroy
    if current_user.role_id == 1 || current_user.role_id == 4
      @patient = Patient.find(params[:id])
      @patient.destroy
      respond_to do |format|
        format.html {redirect_to patient_index_path, notice: 'Patient was successfully destroyed.'}
        format.json {head :no_content}
      end
    else
      redirect_to patient_index_path
    end
  end

  private
  def set_patient
    #begin
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender,
                                 :contact, :username, :province, :city_village, :address_line_1, :role_id, :blood_type_id, :user_id)
  end

  def sort_column
    Patient.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
