class AppointmentController < ApplicationController
  #before_action :find_doctor

  def new
    @appointment = Appointment.new
    @appointment.patient = Patient.find(params[:patient_id])
    #@appointment.doctor = Doctor.find(params[:doctor_id])

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


  def destroy
    @appointment.destroy
    redirect_to patient_index_path
  end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :patient_id, :appointment_date)
    #params.require(:participation).permit( :id, :event_id, :first_name, :last_name, :status)
  end

  def find_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end
end