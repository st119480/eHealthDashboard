class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction, :chart_patient, :high_bp, :low_bp, :overall_condition, :high_blood_sugar, :low_blood_sugar, :low_oxygen_saturation, :dashboard, :doctor_specialty
  helper_method :bp_systolic, :bp_diastolic, :blood_sugar_fasting, :blood_sugar_pp, :blood_oxygen_saturation, :bmi, :top_5_high_bp, :top_5_low_bp, :top_5_high_blood_sugar, :top_5_low_blood_sugar

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
        format.html {redirect_to user_index_path, notice: 'User was successfully deleted.'}
        format.json {head :no_content}
      end
    else
      redirect_to user_index_path
    end
  end

  def dashboard
    if current_user.role_id == 1
      if params[:province] == nil || params[:province] == ''
        whereCondition = " WHERE 1 = 1"
        @count_users = User.find_by_sql("SELECT  actable_type, COUNT(distinct id) as user_count FROM users " + whereCondition + "
                                  GROUP BY  actable_type
                                  ORDER BY actable_type;")
      else
        prov = params[:province].fetch("province_id")
        dist = params[:district].fetch("district_id")
        if (dist.to_i >= 880 && dist.to_i <= 956)

          whereCondition = " WHERE province_id = '#{prov}' "
        else
          whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}' "
        end

        @count_users = User.find_by_sql("SELECT actable_type, COUNT(distinct id) as user_count FROM users "  + whereCondition + "
                                  GROUP BY actable_type
                                  ORDER BY actable_type;")
      end
    else
      render :show
    end
  end

  def doctor_specialty
    if current_user.role_id == 1
      if params[:province] == nil || params[:province] == ''
        whereCondition = " WHERE 1 = 1"
        @doctor_specialty = User.find_by_sql("select s.description, count(distinct d.id) as doctor_count from doctors d
                                          inner join specialties s
                                          on d.specialty_id = s.id " + whereCondition + "
                                  group by s.description
                                  order by s.description;")
      else
        prov = params[:province].fetch("province_id")
        dist = params[:district].fetch("district_id")
        if (dist.to_i >= 880 && dist.to_i <= 956)

          whereCondition = " WHERE province_id = '#{prov}' "
        else
          whereCondition = " WHERE province_id = '#{prov}' AND district_id =  '#{dist}' "
        end

        @doctor_specialty = User.find_by_sql("select s.description, count(distinct d.id) as doctor_count from doctors d
                                          inner join specialties s
                                          on d.specialty_id = s.id
                                          inner join users u
                                          on d.user_id = u.id "  + whereCondition + "
                                  group by s.description
                                  order by s.description;")
      end
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


  def bp_systolic
    @bp_systolic = Test.find_by_sql("select to_char(test_date, 'YYYY-MM') as test_month, avg(bp_systolic) as bp_systolic
                              from tests a
                              inner join users b
                              on a.patient_id = b.actable_id
                              and b.actable_type = 'Patient'
                              where b.id  = '#{params[:id]}'
                              and  test_date >= current_date - interval '1 year'
                              group by to_char(test_date, 'YYYY-MM')
                              order by test_month desc;")
  end

  def bp_diastolic
    @bp_diastolic = Test.find_by_sql("select to_char(test_date, 'YYYY-MM') as test_month, avg(bp_diastolic) as bp_diastolic
                              from tests a
                              inner join users b
                              on a.patient_id = b.actable_id
                              and b.actable_type = 'Patient'
                              where b.id  = '#{params[:id]}'
                              and  test_date >= current_date - interval '1 year'
                              group by to_char(test_date, 'YYYY-MM')
                              order by test_month desc;")
  end

  def blood_sugar_fasting
    @blood_sugar_fasting = Test.find_by_sql("select to_char(test_date, 'YYYY-MM') as test_month, avg(blood_sugar_fasting) as blood_sugar_fasting
                              from tests a
                              inner join users b
                              on a.patient_id = b.actable_id
                              and b.actable_type = 'Patient'
                              where b.id  = '#{params[:id]}'
                              and  test_date >= current_date - interval '1 year'
                              group by to_char(test_date, 'YYYY-MM')
                              order by test_month desc;")
  end

  def blood_sugar_pp
    @blood_sugar_pp = Test.find_by_sql("select to_char(test_date, 'YYYY-MM') as test_month, avg(blood_sugar_pp) as blood_sugar_pp
                              from tests a
                              inner join users b
                              on a.patient_id = b.actable_id
                              and b.actable_type = 'Patient'
                              where b.id  = '#{params[:id]}'
                              and  test_date >= current_date - interval '1 year'
                              group by to_char(test_date, 'YYYY-MM')
                              order by test_month desc;")
  end

  def bmi
    @bmi = Test.find_by_sql("select to_char(test_date, 'YYYY-MM') as test_month, avg(bmi) as bmi
                              from tests a
                              inner join users b
                              on a.patient_id = b.actable_id
                              and b.actable_type = 'Patient'
                              where b.id  = '#{params[:id]}'
                              and  test_date >= current_date - interval '1 year'
                              group by to_char(test_date, 'YYYY-MM')
                              order by test_month desc;")
  end

  def blood_oxygen_saturation
    @blood_oxygen_saturation = Test.find_by_sql("select to_char(test_date, 'YYYY-MM') as test_month, avg(blood_oxygen_saturation) as blood_oxygen_saturation
                              from tests a
                              inner join users b
                              on a.patient_id = b.actable_id
                              and b.actable_type = 'Patient'
                              where b.id  = '#{params[:id]}'
                              and  test_date >= current_date - interval '1 year'
                              group by to_char(test_date, 'YYYY-MM')
                              order by test_month desc;")
  end

  def top_5_high_bp
    @top_5_high_bp = Test.find_by_sql("select province, count(distinct user_id) as user_count from high_bp
                      group by province
                      order by 2 desc
                      limit 5;")
  end

  def top_5_low_bp
    @top_5_low_bp = Test.find_by_sql("select province, count(distinct user_id) as user_count from low_bp
                      group by province
                      order by 2 desc
                      limit 5;")
  end

  def top_5_high_blood_sugar
    @top_5_high_blood_sugar = Test.find_by_sql("select province, count(distinct user_id) as user_count from high_blood_sugar
                      group by province
                      order by 2 desc
                      limit 5;")
  end

  def top_5_low_blood_sugar
    @top_5_low_blood_sugar = Test.find_by_sql("select province, count(distinct user_id) as user_count from low_blood_sugar
                      group by province
                      order by 2 desc
                      limit 5;")
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

  def set_location
    if params[:province] == nil || params[:province] == ''
      @prov_name = 0
    else
      prov_id = params[:province].fetch("province_id")
      #@prov_name = Province.find_by_sql("SELECT name FROM provinces WHERE id = "  + prov_id + ";")
      @prov_name = Province.find(prov_id)

    end

    if params[:district] == nil || params[:district] == ''
      @dist_name = 0
    else
      dist_id = params[:district].fetch("district_id")
      @dist_name = District.find(dist_id)
      #@dist_name = District.find_by_sql("SELECT district_name FROM districts WHERE id = "  + dist_id + ";")
    end

  end



end
