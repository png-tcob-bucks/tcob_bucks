class RolesController < ApplicationController

		include SessionsHelper

	before_filter :authenticate_user_logged_in

	def add_to_role
		Permission.new(role_id: params[:role], job_id: params[:job]).save
		redirect_to action: 'assign'
	end

	def assign
		if @current_user.has_admin_access
			@role = Role.find(params[:id])
			@permitted = @role.jobs
			@jobs_all = Job.all.order(:title)

		else 
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to edit roles.'
			redirect_to controller: :employees, action: 'show', id: @current_user.id
		end
	end

	def create
		Role.new(role_params).save
		flash[:title] = 'Success'
		flash[:notice] = role_params[:title] + ' has been created.'
		redirect_to action: 'index'
	end

	def delete
		@role = Role.find(params[:id]).delete
		Permission.where(role_id: @role.id).each do |p|
			p.delete
		end
		flash[:title] = 'Success'
		flash[:notice] = @role.title + ' has been deleted.'
		redirect_to action: 'index'
	end

	def edit
		@role = Role.find(params[:id])
	end

	def index
		@roles = Role.all.order(:title)
		@jobs_unassigned = Job.joins('LEFT JOIN permissions ON permissions.job_id = jobs.jobcode WHERE permissions.job_id IS NULL').order(:title)
	end

	def new

	end

	def remove_from_role
		Permission.find_by(role_id: params[:role], job_id: params[:job_id]).delete
		# query = "DELETE FROM permissions WHERE permissions.role_id='#{@perm.role_id}' AND permissions.job_id='#{@perm.job_id}'"
		redirect_to action: 'assign'
	end

	def update
		@role = Role.find(params[:id])
		@role.update_attributes(role_params)
		flash[:title] = 'Success'
		flash[:notice] = role_params[:title] + ' has been updated.'
		redirect_to action:'index'
	end

	def unassign
		if @current_user.has_admin_access
			@role = Role.find(params[:id])
			@permitted = @role.jobs
			@jobs_all = Job.all.order(:title)
		else 
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to edit roles.'
			redirect_to controller: :employees, action: 'show', id: @current_user.id
		end
	end

	private 
	def role_params
		params.require(:role).permit(:title, :issue, :approve, :redeem, :admin, :view_all, :inventory,
		:recieve, :view_dept, :issue_gold, :access, :feedback )
	end

end
