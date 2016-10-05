class EmployeesController < ApplicationController
	include ApplicationHelper
	include EmployeesHelper
	include SessionsHelper
	include PermissionsHelper
	include EmployeesImportHelper

	before_filter :authenticate_user_logged_in

	def achievements
		
	end

	def create
		@employee = Employee.new(employee_params)
		if @employee.save
			log_in @employee
			redirect_to :action => 'index'
		else
			render :action => 'create'
		end
	end

	def edit
		if @current_user.has_admin_access
			@user = Employee.find(session[:id])
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to edit employees.'
			render 'index'
		end
	end

	def home
		@featured = Prize.where(available: true, featured: true).group(:name)
		@top_aplus = Employee.top10_aplus
		@top_attendance = Employee.top10_attendance
		@top_community = Employee.top10_community
		@top_service = Employee.top10_service
		@top_shift = Employee.top10_shift
		@top_other = Employee.top10_other
	end

	def import
		import_employees
		@employees = Employee.all
		render 'index'
	end

	def index
		if @current_user.has_admin_access
			@employees = Employee.search(params[:search_id], params[:search_first_name], params[:search_last_name]).where(status: 'Active')
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view those employees.'
			render 'index'
		end
	end

	def show
		@employee = Employee.find(params[:id])
		@purchases = Purchase.where(employee_id: @employee.id).where(returned: false)
		if @current_user.can_view_employee(@employee) || @employee.id == @current_user.id
			@bucks = Buck.where(employee_id: @employee.id).where(status: ['Active','Partial']).order(sort_buck_column + " " + sort_buck_direction)
			@bucks_month = @bucks.select { |b| b.this_month? }
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to view that employee.'
			redirect_to action: :show, id: @current_user.id
		end
	end

	def team
		if @current_user.can_view_dept
			@employees = Employee.where(status: "Active").where(department_id: @current_user.department_id).search_preshow(params[:search_id], params[:search_first_name], params[:search_last_name]).order(:last_name)
			if params[:sort] == 'earnedThisMonth'
				@employees = @employees.sort_by_earned_month.reverse
			end
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view an entire department.'
			render 'index'
		end
	end

	private 
		def employee_params
			params.require(:employees).permit(:id, :IDnum, :first_name, :last_name, :role, :department_id, :job_id)
		end

end
