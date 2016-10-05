class BucksController < ApplicationController
	include ApplicationHelper
	include BucksHelper
	include SessionsHelper
	include BucksImportHelper

	helper_method :sort_buck_column, :sort_buck_direction
	before_filter :authenticate_user_logged_in

	def analyze
		if @current_user.has_admin_access
			@departments = Department.all
			@months = Buck.group("month(bucks.approved_at)").map { |b| b.approved_at.strftime("%B") if !b.approved_at.nil? } 
			@years = Buck.group("year(bucks.approved_at)").map { |b| b.approved_at.strftime("%Y") if !b.approved_at.nil? }
			@bucks = Buck.search_dept(params[:department], params[:month], params[:year]).order(sort_buck_column + " " + sort_buck_direction)

			if !params[:department].blank? && !params[:month].blank? && !params[:year].blank?
				@department = Department.find(params[:department])
				@month = params[:month] if !params[:month].blank?
				@year = params[:year] if !params[:year].blank?
				@department_budget = @department.get_budget_overall
				@budget_per_employee = @department.get_budget_per_employee
				@employees = Employee.where(department_id: @department.id).order(:last_name).select { |e| e.can_issue_bucks }
			end
		else 
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view that buck.'
			render 'show'
		end
	end

	def approve
		if @current_user.can_view_buck(Buck.find(params[:id]))
			@buck = Buck.find(params[:id])
		else 
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view that buck.'
			render 'show'
		end
	end

	def create

		@buck = Buck.new(bucks_params)
		valid_buck = true

		if params[:buck][:employee_id] == ''
			@buck.errors.add(:employee_id, "Must enter a valid Employee ID")
			valid_buck = false
		end

		if @buck.reason_short == ''
			@buck.errors.add(:reason_short, "Must provide a reason for issuing buck")
			valid_buck = false
		end

		if (@buck.reason_short == 'Customer Service' || @buck.reason_short == 'Other') && @buck.reason_long == ''
			@buck.errors.add(:reason_long, "Must provide a reason for issuing buck if issuing for Customer Service or Other")
			valid_buck = false
		end

		if valid_buck
			@buck.assignedBy = Employee.find(session[:id]).id
			@employee = Employee.find(@buck.employee_id)
			@buck.department_id = @employee.department_id
			@buck.number = assign_buck_number
			if @buck.needs_approval(@current_user, @employee)
				@buck.status = "Pending"
			else
				@buck.status = "Active"
				@buck.expires = Time.now.advance(:years => +1)
				@buck.approved_at = Time.now
			end
			
			@buck.save

			if @buck.reason_short == 'Other'
				Mailer.pending_buck_approval(@current_user, @buck).deliver_now
			end

			buck_log_params = { :buck_id => @buck.id, 
				:event => 'Issued', 
				:performed_id => @current_user.id,
				:recieved_id => @employee.id,
				:value_before => @buck.value,
				:value_after => @buck.value,
				:status_before => @buck.status,
				:status_after => @buck.status }
			BuckLog.new(buck_log_params).save

			redirect_to :action => 'show', id: @buck.id
			flash[:title] = 'Success'
			flash[:notice] = 'Buck has been submitted!'

			
		else
			flash[:title] = 'Error'
			flash[:notice] = @buck.errors.messages
			redirect_to :action => 'new'
		end
	end

	def delete
		@buck = Buck.find(params[:id])
		
		flash[:title] = 'Success'
		flash[:notice] = 'Buck ' + params[:id] + ' has been successfully voided!'

		buck_log_params = { :buck_id => @buck.id, 
			:event => 'Voided', 
			:performed_id => @current_user.id,
			:recieved_id => @current_user.id,
			:value_before => @buck.value,
			:value_after => @buck.value,
			:status_before => @buck.status,
			:status_after => 'Void' }
		BuckLog.new(buck_log_params).save

		@buck.update_attributes(status: 'Void')
		redirect_to :action => 'index'
	end

	def import
		import_bucks
		redirect_to action: 'index'
	end
	
	def index
		if @current_user.has_admin_access || @current_user.can_view_all
			
			if params[:sort] == 'employeeName'
				@bucks = Buck.search(params[:search_number], params[:search_recipient_id], params[:search_issuer_id]).sort_by(&:get_employee_name)
			else
				@bucks = Buck.search(params[:search_number], params[:search_recipient_id], params[:search_issuer_id]).order(sort_buck_column + " " + sort_buck_direction)
			end
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view all bucks.'
			render 'index'
		end
	end

	def issued
		@department = Department.find(@current_user.department_id)
		@department_budget = @department.get_budget_overall
		@budget_per_employee = @department.get_budget_per_employee

		if params[:show] == 'you'
			@show = 'you'
			if !Buck.where(assignedBy: @current_user.id).blank?
				@bucks = Buck.where('extract(month from approved_at) = ?', Time.now.strftime("%m")).where(assignedBy: @current_user.id).order(sort_buck_column + " " + sort_buck_direction)
			end
		elsif params[:show] == 'department'
			@show = 'department'
			@bucks = Buck.where('extract(month from approved_at) = ?', Time.now.strftime("%m"))
			@bucks = @bucks.select { |b| Employee.find(b.assignedBy).department_id == @current_user.department_id }
		end
	end

	def logs
		if @current_user.has_admin_access
			@buck_logs = BuckLog.search(params[:buck_id], params[:performed_id], params[:recieved_id])
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view these logs.'
			render 'logs'
		end
	end

	def new
		@employees = Employee.search(params[:search_id], params[:search_first_name], params[:search_last_name]).where(status: 'Active')
	end

	def pending
		if @current_user.can_approve_bucks
			@bucks = Buck.where(department_id: @current_user.department_id).where(status: ['Pending']).order(sort_buck_column + " " + sort_buck_direction)
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to approve bucks.'
			render 'pending'
		end
	end

	def show
		if @current_user.can_view_buck(Buck.find(params[:id]))
			@buck = Buck.find(params[:id])
		else 
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view that buck.'
			render 'show'
		end
	end

	def update
		@buck = Buck.find(params[:id])

		buck_log_params = { :buck_id => @buck.id,  
			:performed_id => @current_user.id,
			:recieved_id => @buck.employee_id,
			:value_before => @buck.value,
			:status_before => @buck.status }
		
		if @current_user.can_approve_bucks || @current_user.has_admin_access 
			if params[:decision] == 'Approve'
				@buck.update_attribute(:status, 'Active')
				@buck.update_attribute(:expires, Time.now.advance(:years => +1))
				@buck.update_attribute(:approved_at, Time.now)
				@buck.update_attribute(:value, params[:buck][:value])

				buck_log_params[:value_after] = params[:buck][:value]
				buck_log_params[:event] = 'Approved'
				buck_log_params[:status_after] = 'Approved'

				flash[:title] = 'Success'
				flash[:notice] = 'Buck has been approved'
				BuckLog.new(buck_log_params).save

				approved_buck_log_params = { :buck_id => @buck.id,  
					:performed_id => @buck.assignedBy,
					:recieved_id => @buck.employee_id,
					:event => 'Activated',
					:value_before => @buck.value,
					:value_after => params[:buck][:value],
					:status_before => 'Pending',
					:status_after => 'Active' }
				BuckLog.new(approved_buck_log_params).save
				redirect_to @buck
			elsif params[:decision] == 'Deny'
				@buck.update_attribute(:status, 'Denied')
				@buck.update_attribute(:value, 0)
				buck_log_params[:value_after] = 0
				buck_log_params[:event] = 'Denied'
				buck_log_params[:status_after] = 'Void'

				flash[:title] = 'Success'
				flash[:notice] = 'Buck has been denied'
				BuckLog.new(buck_log_params).save
				redirect_to @buck
			else
				flash.now[:title] = 'Error'
				flash.now[:notice] = @buck.errors.messages
				render 'approve'
			end
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to approve bucks'
			redirect_to :action => 'index'
		end
	end

	private 
	def bucks_params
		params.require(:buck).permit(:value, :reason_short, :reason_long, :prize_id, :decision, :employee_id)
	end

	def makePurchase(prize, employee, item)
		perform_bucks_purchase_transaction(prize, employee)
		item.update_attribute(:status, 'Purchased')

		store_log_params = { :employee_id => employee.id, 
				:cashier_id => @current_user.id, 
				:prize_id => prize.id,
				:item_barcode => item.barcode,
				:trans => "Purchased",
				:balance_before => balance_before,
				:balance_after => employee.get_bucks_balance }

		StoreLog.new(store_log_params).save
	end

	def request_order(prize, employee)
		perform_bucks_purchase_transaction(prize, employee)
		@item = Item.new(name: prize.name, prize_id: prize.id, status: "Ordered")
		@item.save

		store_log_params = { :employee_id => employee.id, 
				:cashier_id => @current_user.id, 
				:prize_id => prize.id,
				:trans => "Ordered",
				:item_id => @item.id,
				:balance_before => employee.get_bucks_balance,
				:balance_after => employee.get_bucks_balance 
			}
		StoreLog.new(store_log_params).save
	end

	def perform_bucks_purchase_transaction(prize, employee)
		balance_before = employee.get_bucks_balance
		spent = 0

		while spent < prize.cost
			@oldest_buck = Buck.where(status: ['Active', 'Partial']).where(employee_id: @employee.id).order(:approved_at).first
			spent = spent + @oldest_buck.value

			buck_log_params = { :buck_id => @oldest_buck.id, 
				:event => 'Spent', 
				:performed_id => @current_user.id,
				:recieved_id => employee.id,
				:value_before => @oldest_buck.value,
				:status_before => @oldest_buck.status,
				:purchased => prize.id }

			if spent > prize.cost
				@oldest_buck.update_attribute(:value, (spent - prize.cost))
				@oldest_buck.update_attribute(:status, 'Partial')

				buck_log_params[:value_after] = spent - prize.cost
				buck_log_params[:status_after] = 'Partial'
			else
				@oldest_buck.update_attribute(:status, 'Redeemed')
				buck_log_params[:status_after] = 'Redeemed'
				buck_log_params[:value_after] = 0
			end

			BuckLog.new(buck_log_params).save
		end
	end

end
