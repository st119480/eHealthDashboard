class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction


  def index
    if current_user.role_id == 1
      @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 15, :page => params[:page])
    else
      render :show
    end
  end

  def show
    if current_user != @user
      redirect_to root_path
    else
      @user = User.find(params[:id])
    end
  end

  def new
    if current_user.role_id == 1
      @user = User.new
    else
      render :show
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_index_path, notice: "User created successfully !!! "
    else
      redirect_to user_index_path, notice: "User was not created !!! "
    end
  end

  def edit
    if current_user.role_id == 1
      @user = User.find(params[:id])
    else
      redirect_to user_index_path
    end
  end

  def update
    if current_user.role_id == 1
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to user_index_path, notice: "User was edited successfully !!! "
      else
        render 'new', danger: "User edit unsuccessful !!! "
      end
    else
      redirect_to user_index_path
    end
  end

  def destroy
    if current_user.role_id == 1
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html {redirect_to user_index_path, notice: 'User was successfully destroyed.'}
        format.json {head :no_content}
      end
    else
      redirect_to user_index_path
    end
  end

  def dashboard
    if current_user.role_id == 1
      @d_users = User.group(:actable_type).count(:id)
      @doc_spec = Doctor.select("count(doctors.id) AS doc_cnt, specialties.description AS spec_description").joins(" INNER JOIN specialties ON
                  specialties.id = doctors.specialty_id ").group("specialties.description").count(:id)
    else
      render :show
    end
  end

  def plot_tests
    if @user.role_id == 3
      @plot_test = Test.select("pulse_rate, testdate")
    end
  end

  private
  def set_user
    #begin
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender,
                                 :contact, :username, :province, :city_village, :address_line_1, :role_id,
                                 :actable_id , :actable_type )
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
