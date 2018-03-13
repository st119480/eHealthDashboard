class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.role_id == 1
      @users = User.all.order(updated_at: :desc)
    else
      render :show
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def set_user
    #begin
    @user = User.find(params[:id])
  end

end
