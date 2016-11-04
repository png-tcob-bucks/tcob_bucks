class PurchasesController < ApplicationController
	include BucksHelper
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def complete
		@employee = Employee.find(params[:employee][:id])
		if params[:prize][:id] != ''
			@prize = Prize.find(params[:prize][:id])
			@prize_subcat = PrizeSubcat.find(params[:prize][:subcat_id])
			quantity = params[:prize][:quantity].to_i
			cost = @prize.cost
			cost = cost.to_s.delete('$').to_i
			 
			if (@employee.get_bucks_balance >= ( cost * quantity )) && quantity > 0
				if @prize_subcat.stock > 0 || @prize.must_order
					if params[:online]
							quantity.times do
								purchase = request_order(@prize, @prize_subcat, @employee)
								perform_bucks_purchase_transaction(@prize, @employee, purchase)
							end
							Mailer.order_notify(@prize, @prize_subcat, @employee, quantity).deliver_now
							flash[:title] = 'Success'
							flash[:notice] = 'Item is reserved! Once the order has been processed, 
							you can find the prize in your wardrobe bag or pick it up from wardrobe during open hours. If it is a large item, you will be able to pick it up at security.'
							redirect_to employee_path(@employee)
					else
						if @current_user.can_manage_inventory && !@prize.must_order
							quantity.times do
								purchase = makePurchase(@prize, @prize_subcat, @employee)
								perform_bucks_purchase_transaction(@prize, @employee, purchase)
							end
							flash[:title] = 'Success'
							flash[:notice] = 'Purchase confirmed'
							redirect_to employee_path(@employee)
						else
							quantity.times do
								purchase = reserve(@prize, @prize_subcat, @employee)
								perform_bucks_purchase_transaction(@prize, @employee, purchase)
							end
							flash[:title] = 'Success'
							flash[:notice] = 'Item is reserved, but must be ordered by HR.'
							redirect_to controller: :prizes, action: :show, id: @prize.id
						end
					end
				else
					flash[:title] = 'Error'
					flash[:notice] = 'Out of stock.'
					redirect_to controller: :prizes, action: :show, id: @prize.id
				end
			else
				flash[:title] = 'Error'
				flash[:notice] = 'Not enough bucks to purchase for that quantity'
				redirect_to controller: :prizes, action: :show, id: @prize.id
			end
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You must select a prize'
			redirect_to action: :finish, id: @employee.IDnum
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
		if @current_user.can_manage_inventory
			@employee = Employee.find(params[:id])
			@prizes = Prize.select("prizes.*, prize_subcats.*").where(available: true).joins(:prize_subcats).subsearch(params[:name], params[:size], params[:color])
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to manage store transactions.'
			redirect_to action: :orders_personal
		end
	end

	def manage
		@employee = Employee.find(params[:employee])
		@purchases = Purchase.where(employee_id: params[:employee])
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
				@oldest_buck.update_attribute(:value, 0)
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

	def refund
		@purchase = Purchase.find(params[:purchase_id])
		@refund = Prize.find(params[:prize_id]).cost
		@bucks_used = BuckLog.where(purchase_id: params[:purchase_id])

		@bucks_used.each do |b|
			buck = Buck.find(b.buck_id)
			if @refund - getBuckValue(buck.reason_short) >= 0
				BuckLog.new(:buck_id => buck.id, 
					:event => 'Refunded', 
					:performed_id => @current_user.id,
					:recieved_id => buck.employee_id,
					:value_before => buck.value,
					:value_after => getBuckValue(buck.reason_short),
					:status_before => buck.status,
					:status_after => "Active",
					:purchase_id => @purchase.id).save

				buck.update_attribute(:value, getBuckValue(buck.reason_short))
				buck.update_attribute(:status, "Active")
			else
				BuckLog.new(:buck_id => buck.id, 
					:event => 'Refunded', 
					:performed_id => @current_user.id,
					:recieved_id => buck.employee_id,
					:value_before => buck.value,
					:value_after => buck.value + @refund,
					:status_before => buck.status,
					:status_after => "Partial",
					:purchase_id => @purchase.id).save

				buck.update_attribute(:value, buck.value + @refund)
				buck.update_attribute(:status, "Partial")
			end

			@refund = @refund - getBuckValue(buck.reason_short)
			
		end

		prize_subcat = PrizeSubcat.find(params[:prize_subcat])
		prize_subcat.stock = prize_subcat.stock + 1

		StoreLog.new(:employee_id => @purchase.employee_id, 
			:cashier_id => @current_user.id, 
			:purchase_id => @purchase.id,
			:prize_id => params[:prize_id],
			:prize_subcat_id => params[:prize_subcat],
			:trans => "Returned").save


		@purchase.update_attribute(:returned, true)
		@purchase.update_attribute(:status, "Returned")
		flash[:title] = 'Success'
		flash[:notice] = 'Employee has been refunded.'
		redirect_to action: :start_manage
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

	def reserve(prize, prize_subcat, employee)
		if prize_subcat.stock > 0
			stock_before = prize_subcat.stock
			prize_subcat.update_attribute(:stock, prize_subcat.stock - 1)
			purchase = Purchase.new(:prize_id => prize.id,
					:prize_subcat_id => prize_subcat.id,
					:employee_id => employee.id,
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

	def start_purchase
		if @current_user.can_manage_inventory
			@employees = Employee.search_all(params[:search_id], params[:search_first_name], params[:search_last_name])	
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to manage store transactions.'
			redirect_to action: :orders_personal
		end
	end

	def start_manage
		@employees = Employee.search_all(params[:search_id], params[:search_first_name], params[:search_last_name])	
	end

end
