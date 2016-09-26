class AdminController < ApplicationController
	include ApplicationHelper
	include BucksHelper
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def dept_budgets
		@departments = Department.all
	end

	def edit_dept_budgets
		@departments = Department.find(params[:department_ids])
		@values = params[:department_values]
		@departments.each do |d|
			d.update_attribute(:value, @values.get(d.id))
		end

		redirect_to 'bucks'
	end

	def feedback

	end

	def feedback_deliver
		message = params[:feedback_message]
		Mailer.mail_feedback(message).deliver_now
		flash.now[:title] = 'Success'
		flash.now[:notice] = 'Your message has been received. Thank you.'
		render 'feedback'
	end
	
end
