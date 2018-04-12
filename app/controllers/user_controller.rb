class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction, :chart_patient, :high_bp, :low_bp, :overall_condition, :high_blood_sugar, :low_blood_sugar, :low_oxygen_saturation

  def index
    if current_user.role_id == 1
      @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
    elsif current_user.role_id == 4
      @users = User.search(params[:search]).where('role_id <> 1').order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
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
    if current_user.role_id == 1 || current_user.role_id == 4
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
    if current_user.role_id == 1 || current_user.role_id == 4
      @user = User.find(params[:id])
    else
      redirect_to user_index_path
    end
  end

  def update
    if current_user.role_id == 1 || current_user.role_id == 4
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
    if current_user.role_id == 1 || current_user.role_id == 4
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

  def high_bp
    if params[:province] == nil || params[:province] == ''
      whereCondition = " WHERE 1 = 1
                          AND test_date >= current_date - interval '1 year'"
      @high_bp = Test.find_by_sql("SELECT  to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM high_bp " + whereCondition + "
                                GROUP BY  to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc;")
    else
      prov = params[:province].fetch("province_id")
      dist = params[:district].fetch("district_id")
      if (dist.to_i >= 880 && dist.to_i <= 956)

        whereCondition = " WHERE province_id = '#{prov}'
                          AND test_date >= current_date - interval '1 year'"
      else
        #prov = params[:province].fetch("province_id")

        whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}'
                          AND test_date >= current_date - interval '1 year'"
      end

      @high_bp = Test.find_by_sql("SELECT province, to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM high_bp "  + whereCondition + "
                                GROUP BY province, to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc, province;")
    end

  end

  def low_bp
    if params[:province] == nil || params[:province] == ''
      whereCondition = " WHERE 1 = 1
                          AND test_date >= current_date - interval '1 year'"
      @low_bp = Test.find_by_sql("SELECT  to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM low_bp " + whereCondition + "
                                GROUP BY  to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc;")
    else
      prov = params[:province].fetch("province_id")
      dist = params[:district].fetch("district_id")
      if (dist.to_i >= 880 && dist.to_i <= 956)

        whereCondition = " WHERE province_id = '#{prov}'
                          AND test_date >= current_date - interval '1 year'"
      else
        #prov = params[:province].fetch("province_id")

        whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}'
                          AND test_date >= current_date - interval '1 year'"
      end

      @low_bp = Test.find_by_sql("SELECT province, to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM low_bp " + whereCondition + "
                                GROUP BY province, to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc, province;")
    end
  end

  def high_blood_sugar
    if params[:province] == nil || params[:province] == ''
      whereCondition = " WHERE 1 = 1
                          AND test_date >= current_date - interval '1 year'"
      @high_blood_sugar = Test.find_by_sql("SELECT  to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM high_blood_sugar " + whereCondition + "
                                GROUP BY  to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc;")
    else
      prov = params[:province].fetch("province_id")
      dist = params[:district].fetch("district_id")
      if (dist.to_i >= 880 && dist.to_i <= 956)

        whereCondition = " WHERE province_id = '#{prov}'
                          AND test_date >= current_date - interval '1 year'"
      else
        #prov = params[:province].fetch("province_id")

        whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}'
                          AND test_date >= current_date - interval '1 year'"
      end
      @high_blood_sugar = Test.find_by_sql("SELECT province, to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM high_blood_sugar "  + whereCondition + "
                                GROUP BY province, to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc, province;")
    end

  end

  def low_blood_sugar
    if params[:province] == nil || params[:province] == ''
      whereCondition = " WHERE 1 = 1
                          AND test_date >= current_date - interval '1 year'"
      @low_blood_sugar = Test.find_by_sql("SELECT  to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM low_blood_sugar " + whereCondition + "
                                GROUP BY  to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc;")
    else
      prov = params[:province].fetch("province_id")
      dist = params[:district].fetch("district_id")
      if (dist.to_i >= 880 && dist.to_i <= 956)

        whereCondition = " WHERE province_id = '#{prov}'
                          AND test_date >= current_date - interval '1 year'"
      else
        #prov = params[:province].fetch("province_id")

        whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}'
                          AND test_date >= current_date - interval '1 year'"
      end
      @low_blood_sugar = Test.find_by_sql("SELECT province, to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM low_blood_sugar " + whereCondition + "
                                GROUP BY province, to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc, province;")
    end
  end

  def low_oxygen_saturation
    if params[:province] == nil || params[:province] == ''
      whereCondition = " WHERE 1 = 1
                          AND test_date >= current_date - interval '1 year'"
      @low_oxygen_saturation = Test.find_by_sql("SELECT  to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM low_oxygen_saturation " + whereCondition + "
                                GROUP BY  to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc;")
    else
      prov = params[:province].fetch("province_id")
      dist = params[:district].fetch("district_id")
      if (dist.to_i >= 880 && dist.to_i <= 956)

        whereCondition = " WHERE province_id = '#{prov}'
                          AND test_date >= current_date - interval '1 year'"
      else
        #prov = params[:province].fetch("province_id")

        whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}'
                          AND test_date >= current_date - interval '1 year'"
      end
      @low_oxygen_saturation = Test.find_by_sql("SELECT province, to_char(test_date, 'YYYY-MM') as test_month,
                                COUNT(distinct user_id) as num_patients FROM low_oxygen_saturation "  + whereCondition + "
                                GROUP BY province, to_char(test_date, 'YYYY-MM')
                                ORDER BY test_month desc, province;")
    end

  end


  def overall_condition
    @overall_condition = Test.find_by_sql("SELECT num_of_patient, condition FROM condition_by_num_of_patient;")
  end

  private
  def set_user
    #begin
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :dob, :gender,
                                 :contact, :username, :province_id, :district_id, :address_line_1, :role_id,
                                 :actable_id , :actable_type,:district )
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
