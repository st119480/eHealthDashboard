class AppointmentController < ApplicationController
  before_action :set_appt, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      @appointment = Appointment.new
      @appointment.patient = Patient.find(params[:patient_id])
      #@appointment.doctor = Doctor.find(params[:doctor_id])
    end

  end

  def create
    begin
      @appointment = Appointment.new(appointment_params)
      @appointment.patient = Patient.find(params[:patient_id])
      #@appointment.doctor = Doctor.find(params[:doctor_id])
      #@appointment.first_name = Participation.new(participation_params[:first_name.to_s])
      #@appointment.last_name = Participation.new(participation_params[:last_name])
      #@appointment.fos = Participation.new(participation_params[:fos])
      if @appointment.save
        redirect_to patient_path(@appointment.patient), notice: "Appointment successful !!! "
      else
        redirect_to patient_path(@appointment.patient), notice: "Appointment unsuccessful !!! "
      end
    end
  end

  def edit
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      @patient = Patient.find(params[:patient_id])
      @appointment = Appointment.find(params[:id])
    else
      redirect_to patient_path(@appointment.patient)
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to patient_path(@appointment.patient), notice: 'Appointment was successfully updated !!!'
    else
      redirect_to patient_path(@appointment.patient), notice: 'Appointment was not updated !!! Please check Provider and Appointment Date !!!'
    end
  end


  def destroy
    if current_user.role_id == 1 || current_user.role_id == 2 || current_user.role_id == 4
      @appointment.destroy
      redirect_to patient_path(@appointment.patient), notice: 'Appointment was successfully deleted !!!'
    else
      redirect_to patient_path(@appointment.patient), notice: 'Appointment was not deleted !!!'
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :patient_id, :appointment_date)
    #params.require(:participation).permit( :id, :event_id, :first_name, :last_name, :status)
  end

  def set_appt
    @appointment = Appointment.find(params[:id])
  end

end
