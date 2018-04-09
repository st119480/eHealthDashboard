class NurseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nurse, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  def index
    if current_user.role_id == 1 || current_user.role_id == 4
      @nurses = Nurse.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
    else
      render :show
    end
  end

  def show
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      @nurse = Nurse.find(params[:id])
    end
  end

  def new
    if current_user.role_id == 1 || current_user.role_id == 4
      @nurse = Nurse.new
      #@user.build_nurse
    else
      render :show
    end
  end

  def create
    @nurse = Nurse.new(nurse_params)
    @nurse.user_id = @nurse.id
    # @nurse = current_user.nurses.build(nurse_params)
    if @nurse.save
      redirect_to nurse_index_path, notice: "Nurse created successfully !!! "
    else
      redirect_to nurse_index_path, notice: "Nurse was not created !!! "
    end
  end

  def edit
    if current_user.role_id == 1 || current_user.role_id == 4
      @nurse = Nurse.find(params[:id])
    else
      redirect_to user_index_path
    end
  end

  def update
    if current_user.role_id == 1 || current_user.role_id == 4
      @nurse = Nurse.find(params[:id])
      if @nurse.update(nurse_params)
        redirect_to nurse_index_path, notice: "Nurse was edited successfully !!! "
      else
        render :edit, notice: "Nurse edit unsuccessful !!! "
      end
    end
  end

  def destroy
    if current_user.role_id == 1 || current_user.role_id == 4
      @nurse = Nurse.find(params[:id])
      @nurse.destroy
      respond_to do |format|
        format.html {redirect_to nurse_index_path, notice: 'Nurse was successfully deleted !!!'}
        format.json {head :no_content}
      end
    else
      redirect_to nurse_index_path
    end
  end

  private
  def set_nurse
    #begin
    @nurse = Nurse.find(params[:id])
  end

  def nurse_params
    params.require(:nurse).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender,
                                   :contact, :username, :province_id, :district_id, :address_line_1, :role_id,
                                   :user_id, :license_num, :qualification)
  end

  def sort_column
    Nurse.joins(nurses: :users).column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
