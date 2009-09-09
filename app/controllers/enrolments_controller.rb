class EnrolmentsController < ApplicationController
  def defer
    @enrolment = Enrolment.find(params[:id])
  end

  def update
    @enrolment = Enrolment.find(params[:id])
    start_date = Date.new(params[:enrolment][:status_changes]['effective_date(1i)'].to_i, 
                          params[:enrolment][:status_changes]['effective_date(2i)'].to_i,
                          params[:enrolment][:status_changes]['effective_date(3i)'].to_i)
    
    approved_date = Date.new(params[:enrolment][:status_changes]['approved_date(1i)'].to_i, 
                             params[:enrolment][:status_changes]['approved_date(2i)'].to_i,
                             params[:enrolment][:status_changes]['approved_date(3i)'].to_i)
    
    if @enrolment.defer(start_date, approved_date)
      flash[:notice] = 'Enrolment deferred'
      redirect_to student_path(@enrolment.student)
    else
      render :action => :defer
    end
    
  end

end
