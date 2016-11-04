class DepartmentsController < ApplicationController
	include SessionsHelper

	before_filter :authenticate_user_logged_in
	
	def approvers
		@dept = Department.find(params[:dept])
		@jobs = Job.all.order(:title)
		@number = params[:number]
	end

	def approver_add
		@dept = Department.find(params[:dept])
		if !params[:jobcode].nil?
			if params[:number] == '1'
				@dept.update_attribute(:approve1, params[:jobcode])
			else
				@dept.update_attribute(:approve2, params[:jobcode])
			end

			@job = Job.find_by(jobcode: params[:jobcode])
			flash[:title] = 'Success'
			flash[:notice] = @job.title + ' has been successfully assigned as an approver #' + params[:number] + ' for ' + @dept.name
			redirect_to action: :edit
		else
			if params[:number] == '1'
				@dept.update_attribute(:approve1, nil)
			else
				@dept.update_attribute(:approve2, nil)
			end

			flash[:title] = 'Success'
			flash[:notice] = 'Approver #' + params[:number] + ' has been reset'
			redirect_to action: :edit
		end	
	end

	def create
		@department = Employee.new(employee_params)
	end

	def edit
		@departments = Department.all.order(name: :asc)
	end

	def test

	end

	def update
		department_ids = params.fetch(:department_ids, "department_ids")
		department_values = params.fetch(:department_values, "department_values")
		valid_input = true

		# Linked to whatever order appearing in the edit action. If order is changed
		# in edit, it must change here also. Department order must match.
		@departments = Department.where(id: department_ids).order(name: :asc)
		@departments.each_with_index do |d, i|
			if (Integer(department_values.at(i)) rescue false)
				d.update_attribute(:budget, department_values.at(i))
			else
				valid_input = false
			end
		end

		if valid_input
			flash.now[:title] = 'Success'
			flash.now[:notice] = 'Budgets have been updated'
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'All input fields must contain a number'
		end

		render 'edit'
	end

		private 
		def department_params
			params.require(:department).permit(:department_ids, :department_values)
		end

end