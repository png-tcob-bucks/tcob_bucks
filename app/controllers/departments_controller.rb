class DepartmentsController < ApplicationController
	include SessionsHelper

	before_filter :authenticate_user_logged_in

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