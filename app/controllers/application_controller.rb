class ApplicationController < ActionController::Base
	include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user_logged_in
	  if session[:id]
	    @current_user = Employee.find(session[:id])
	    return true	
	  else
	  	flash[:title] = "Error"
	  	flash[:notice] = "Login Required"
	    redirect_to login_path
	    return false
	  end
	end	

end