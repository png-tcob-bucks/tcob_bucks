class SessionsController < ApplicationController

	layout 'layout_login'

  def create 
    employee = Employee.find(params[:session][:id])

    if employee && employee.authenticate(params[:session][:password])
      if employee.status == "Terminated"
        flash.now[:title] = "Error"
        flash.now[:notice] = "Access Denied: Please contact Human Resources at 419-661-5276."
        render 'new'
      elsif !employee.has_general_access
        flash.now[:title] = "Error"
        flash.now[:notice] = "Access Denied: Site is currently unavailable due to maintenence or testing. For questions, contact Human Resources at 419-661-5276."
        render 'new'
      else
        log_in employee
        redirect_to employee
      end
    else
      flash.now[:title] = "Error"
      flash.now[:notice] = "Access Denied: Invalid password"
      render 'new'
    end

    rescue ActiveRecord::RecordNotFound
      flash.now[:title] = "Error"
      flash.now[:notice] = "Access Denied: Invalid ID number"
      render 'new'
  end

  def destroy
    log_out
    redirect_to login_url
  end

  def new
  end

end
