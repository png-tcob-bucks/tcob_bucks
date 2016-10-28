class PrizesController < ApplicationController
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def create
		@prize = Prize.new(prize_params)
		@prize.image = '/images/no_image.png' if params[:image].blank?
		if @current_user.can_manage_inventory
			if @prize.save
				flash[:title] = 'Success'
				flash[:notice] = 'Prize has been updated'
				StoreLog.new(:employee_id => @current_user.id, 
					:cashier_id => @current_user.id, 
					:prize_id => @prize.id,
					:trans => 'Created').save
				redirect_to :action => 'manage'
			else
				flash.now[:title] = 'Error'
				flash.now[:notice] = @prize.errors.messages
				render 'new'
			end
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to edit items'
			redirect_to :action => 'index'
		end
	end

	def discontinue
		if @current_user.can_manage_inventory
			@prize = Prize.find(params[:id])
			stock_before = @prize.get_total_stock
			@prize.update_attributes(available: false)
			flash[:title] = 'Success'
			flash[:notice] = @prize.name + ' has been successfully discontinued from the shop!'
			StoreLog.new(:employee_id => @current_user.id, 
				:cashier_id => @current_user.id, 
				:prize_id => @prize.id,
				:trans => 'Discontinued',
				:stock_before => stock_before,
				:stock_after => 0).save
			redirect_to action: :manage
		else 
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to discontinue that item'
			redirect_to action: :index
		end
	end

	def edit
		@prize = Prize.find(params[:id])
	end

	def index
		@prizes = Prize.where(available: true).group(:name)
		@featured = Prize.where(available: true, featured: true).group(:name)
		@filters = params.select { |p,k|  p if p == "color" || p == "name" || p == "size" || p == "category" }
	end

	def logs
		if @current_user.has_admin_access
			@store_logs = StoreLog.search(params[:customer_id], params[:cashier_id], params[:purchase_id])
		else
			flash.now[:title] = 'Error'
			flash.now[:notice] = 'You do not have permission to view these logs.'
			render 'logs'
		end
	end

	def manage
		@prizes = Prize.search(params[:id], params[:name], params[:available])
	end

	def new
		@prize = nil
		@prizes = Prize.all.group(:name).order(:name)
	end

	def show
		@prize = Prize.find(params[:id])
		@featured = Prize.first(5)
		@prize_subcats = PrizeSubcat.where(prize_id: @prize.id)
		@images = @prize_subcats.group(:image).map { |p| p.image if p.image != '' }
		if !@prize_subcats.blank?		
			@prize_subcats = PrizeSubcat.where(prize_id: @prize.id)
			@sizes = @prize_subcats.group(:size).map { |p| p.size }
			@colors = @prize_subcats.group(:color).map { |p| p.color }
			@brands = @prize_subcats.group(:brand).map { |p| p.brand }
			@chosen = PrizeSubcat.search(@prize.id, params[:size], params[:color], params[:brand]).first
			
		else
			flash[:title] = 'Error'
			flash[:notice] = 'Item is currently out of stock or discontinued.'
			redirect_to action: :index
		end
	end

	def stock
		@prize = Prize.find(params[:id])
	end

	def update
		@prize = Prize.find(params[:id])
		if(params.key?("cancel"))
        	redirect_to action: :manage
    	else
			if @current_user.can_manage_inventory
				if @prize.update_attributes(prize_params)
					@prize.update_attributes(image: '/images/no_image.png') if @prize.image.blank?
					flash[:title] = 'Success'
					flash[:notice] = 'Prize has been updated'
					StoreLog.new(:employee_id => @current_user.id, 
						:cashier_id => @current_user.id, 
						:prize_id => @prize.id,
						:trans => 'Updated').save
					redirect_to :action => 'manage'
				else
					flash.now[:title] = 'Error'
					flash.now[:notice] = @prize.errors.messages
					render 'edit'
				end
			else
				flash[:title] = 'Error'
				flash[:notice] = 'You do not have permission to edit items'
				redirect_to action: :index
			end
		end
	end

	private 
		def prize_params
			params.require(:prize).permit(:id, :name, :cost, :must_order, :available, :image, :description, :featured)
		end

end
