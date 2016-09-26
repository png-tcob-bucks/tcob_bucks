class OverrideController < ApplicationController

	def override_data_reset
		Department.delete_all
		Employee.delete_all
		Job.delete_all
		Permission.delete_all
		import_employees
		@employee = Employee.find(session[:id])
		@job = Job.find(@employee.job_id)
		@role = Role.create(title: 'DELETE ME ADMIN', admin: true)
		Permission.create(job_id: @job.id, role_id: @role.id)
		flash[:title] = "Error"
	  flash[:notice] = "!!! Create an administrator account or add yourself to one before you delete the DELETE_ME role."
		redirect_to controller: :roles, action: :index
	end

	def verify
	end

	def process
		if params[:key] == 'lUA0NrgBgdTA1YkpEkFO'
			override_data_reset
		else
			flash[:title] = "Error"
	  	flash[:notice] = "Denied"
			redirect_to controller: :login
		end
	end
end

