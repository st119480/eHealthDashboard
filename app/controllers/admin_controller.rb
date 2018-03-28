class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :set_admin, only: [:show, :edit, :update, :destroy]


  def index
    if current_user.role_id == 1
      @admins = Admin.all.order(updated_at: :desc)
    else
      render :show
    end
  end

  def show
    if current_user.role_id == 1
      @admin = Admin.find(params[:id])
    end
  end

  def new
    if current_user.role_id == 1
      @admin = Admin.new
      #@user.build_admin
    else
      render :show
    end
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.user_id = @admin.id
    # @admin = current_user.admins.build(admin_params)
    if @admin.save
      redirect_to admin_index_path, notice: "Admin created successfully !!! "
    else
      redirect_to admin_index_path, notice: "Admin was not created !!! "
    end
  end

  def edit
    if current_user.role_id == 1
      @admin = Admin.find(params[:id])
    else
      redirect_to user_index_path
    end
  end

  def update
    if current_user.role_id == 1
      @admin = Admin.find(params[:id])
      if @admin.update(admin_params)
        redirect_to admin_index_path, notice: "Admin was edited successfully !!! "
      else
        render :edit, notice: "Admin edit unsuccessful !!! "
      end
    end
  end

  def destroy
    if current_user.role_id == 1
      @admin = Admin.find(params[:id])
      @admin.destroy
      respond_to do |format|
        format.html {redirect_to admin_index_path, notice: 'Admin was successfully deleted !!!'}
        format.json {head :no_content}
      end
    else
      redirect_to admin_index_path
    end
  end

  private
  def set_admin
    #begin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender,
                                  :contact, :username, :province, :city_village, :address_line_1, :role_id, :user_id)
  end
end
