class TestController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_test, only: [:show, :edit, :update, :destroy]

  # GET /tests
  # GET /tests.json
  def index
    @tests = Test.all
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
    @test = @patient.Test.find(params[:id])
  end

  # GET /tests/new
  def new
    if current_user.role_id == 1 || current_user.role_id == 2
      @test = Test.new
      @test.patient = Patient.find(params[:patient_id])
    else
      render :show
    end
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)
    #@test.patient_id = @patient.id
    @test.patient = Patient.find(params[:patient_id])
    respond_to do |format|
      if @test.save
        format.html { redirect_to patient_path(@test.patient), notice: 'Test was created successfully !!!' }
        format.json { render :show, status: :created, location: @test }
      else
        format.html { render :new, notice: 'Test creation unsuccessful !!!' }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to patient_test_index_path, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to patient_test_index_path, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  # Never trust parameters from the scary internet, only allow the white list through.
  def test_params
    params.require(:test).permit(:prev_diagnosis, :prev_medication, :ongoing_medication, :pulse_rate, :body_temperature,
                                 :respiratory_rate, :bp_systolic, :bp_diastolic, :blood_oxygen_saturation, :blood_sugar_pp,
                                 :blood_sugar_fasting, :height, :weight, :bmi, :test_date, :recommendation, :patient_id)
  end

  def set_test
    @test = Test.find(params[:id])
  end

end
