class PurchasesController < ApplicationController
	include BucksHelper
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def complete
		@employee = Employee.find(params[:employee][:id])
		@prize = Prize.find(params[:prize][:id])
		@prize_subcat = PrizeSubcat.find(params[:prize][:subcat_id])
		 
		if @employee.get_bucks_balance >= @prize.cost
			if @prize_subcat.stock > 0 || @prize.must_order
				if @prize.must_order
						purchase = request_order(@prize, @prize_subcat, @employee)
						flash[:title] = 'Success'
						flash[:notice] = 'Request has been submitted. You will recieve an email or notification when your request has been approved'
						redirect_to employee_path(@employee)
				else
					if @current_user.can_manage_inventory
						purchase = makePurchase(@prize, @prize_subcat, @employee)
						flash[:title] = 'Success'
						flash[:notice] = 'Purchase confirmed'
						redirect_to employee_path(@employee)
					else
						purchase = reserve(@prize, @prize_subcat)
						flash[:title] = 'Success'
						flash[:notice] = 'Item is reserved. Once the order has been processed, 
						you can find the prize in your wardrobe bag. If it is a large item, you will be able to pick it up at security.'
						redirect_to controller: :prizes, action: :index
					end
				end
				perform_bucks_purchase_transaction(@prize, @employee, purchase)
			else
				flash[:title] = 'Error'
				flash[:notice] = 'Out of stock.'
				redirect_to controller: :prizes, action: :index
			end
		else
			flash[:title] = 'Error'
			flash[:notice] = 'Not enough bucks to purchase'
			redirect_to controller: :prizes, action: :index
		end
	end

	def confirm
		@purchase = Purchase.find(params[:id])
		@purchase.update_attributes(pickedup_by: nil, status: 'Purchased')
		StoreLog.new(:employee_id => @purchase.employee_id, 
			:cashier_id => @current_user.id, 
			:prize_id => @purchase.prize_id,
			:purchase_id => @purchase.id,
			:trans => "Delivered").save

		flash[:title] = 'Success'
		flash[:notice] = 'Purchase order confirmed and delivered.'
		redirect_to controller: :prizes, action: :index
	end

	def drop
		Purchase.find(params[:id]).update_attributes(pickedup_by: nil)
		redirect_to action: 'orders'
	end

	def exchange
		@employees = Employee.search(params[:search_id], params[:search_first_name], params[:search_last_name])
	end

	def finish
		@employee = Employee.find(params[:id])
		@prizes = Prize.select("prizes.*, prize_subcats.*").where(available: true).joins(:prize_subcats).subsearch(params[:name], params[:size], params[:color])
	end

	def makePurchase(prize, prize_subcat, employee)
		stock_before = prize_subcat.stock

		prize_subcat.update_attribute(:stock, prize_subcat.stock - 1)

		purchase = Purchase.new(:prize_id => prize.id,
				:prize_subcat_id => prize_subcat.id,
				:employee_id => employee.id,
				:cashier_id => @current_user.id,
				:status => "Purchased")
		purchase.save

		StoreLog.new(:employee_id => employee.id, 
				:cashier_id => @current_user.id, 
				:purchase_id => purchase.id,
				:prize_id => prize.id,
				:prize_subcat_id => prize_subcat.id,
				:trans => "Purchased",
				:stock_before => stock_before,
				:stock_after => prize_subcat.stock).save

		return purchase
	end

	def orders
		@orders = Purchase.where(status: 'Ordered').where(pickedup_by: nil)
		@orders_picked_up = Purchase.where(status: 'Ordered').where(pickedup_by: @current_user.id)
	end

	def orders_personal
		@orders = Purchase.where(status: ['Ordered', 'Reserved']).where(employee_id: @current_user.id)
	end

	def perform_bucks_purchase_transaction(prize, employee, purchase)
		balance_before = employee.get_bucks_balance
		spent = 0

		while spent < prize.cost
			@oldest_buck = Buck.where(status: ['Active', 'Partial']).where(employee_id: @employee.id).order(:created_at).first
			spent = spent + @oldest_buck.value

			buck_log_params = { :buck_id => @oldest_buck.id, 
				:event => 'Spent', 
				:performed_id => @current_user.id,
				:recieved_id => employee.id,
				:value_before => @oldest_buck.value,
				:status_before => @oldest_buck.status,
				:purchase_id => purchase.id }

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

	def pickup
		Purchase.find(params[:id]).update_attribute(:pickedup_by, @current_user.id)
		redirect_to action: 'orders'
	end

	def request_order(prize, prize_subcat, employee)
		
		purchase = Purchase.new(:prize_id => prize.id,
				:prize_subcat_id => prize_subcat.id,
				:employee_id => employee.id,
				:cashier_id => @current_user.id,
				:status => "Ordered")
		purchase.save

		StoreLog.new(:employee_id => employee.id, 
				:cashier_id => @current_user.id, 
				:purchase_id => purchase.id,
				:prize_id => prize.id,
				:prize_subcat_id => prize_subcat.id,
				:trans => "Ordered").save

		return purchase
	end

	def reserve(prize, prize_subcat)
		if prize_subcat.stock > 0
			stock_before = prize_subcat.stock
			prize_subcat.update_attribute(:stock, prize_subcat.stock - 1)
			purchase = Purchase.new(:prize_id => prize.id,
					:prize_subcat_id => prize_subcat.id,
					:employee_id => @current_user.id,
					:cashier_id => @current_user.id,
					:status => "Reserved")
			purchase.save

			StoreLog.new(:employee_id => @current_user.id, 
					:cashier_id => @current_user.id, 
					:purchase_id => purchase.id,
					:prize_id => @prize.id,
					:prize_subcat_id => @prize_subcat.id,
					:trans => "Reserved",
					:stock_before => stock_before,
					:stock_after => @prize_subcat.stock).save

			return purchase
		else
				flash[:title] = 'Error'
				flash[:notice] = 'Out of stock.'
				redirect_to action: :show, id: @prize.id
		end
	end

	def reserved
		if @current_user.can_manage_inventory
			@reserved = Purchase.where(status: 'Reserved')
		else 
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to manage all reserved items.'
			redirect_to action: :orders_personal
		end
	end

	def start
		@employees = Employee.search_all(params[:search_id], params[:search_first_name], params[:search_last_name])	
	end

end
