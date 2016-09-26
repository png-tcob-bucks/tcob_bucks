class PrizeSubcatsController < ApplicationController
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def create
		@prize = Prize.find(params[:id])
		@prize_subcat = PrizeSubcat.new(prize_subcat_params)
		@prize_subcat.prize_id = @prize.id
		@prize_subcat.image = @prize_subcat.image

		if @current_user.can_manage_inventory
			if @prize_subcat.save
				flash[:title] = 'Success'
				flash[:notice] = 'New type of prize was added'
				StoreLog.new(:employee_id => @current_user.id, 
					:cashier_id => @current_user.id, 
					:prize_id => @prize.id,
					:prize_subcat_id => @prize_subcat.id,
					:trans => 'Created').save
				redirect_to :action => 'manage'
			else
				flash.now[:title] = 'Error'
				flash.now[:notice] = @prize.errors.messages
				render 'new'
			end
		else
			flash[:title] = 'Error'
			flash[:notice] = 'You do not have permission to add items.'
			redirect_to :action => 'index'
		end
	end

	def edit
		@prize = Prize.find(PrizeSubcat.find(params[:id]).prize_id)
		@prize_subcat = PrizeSubcat.find(params[:id])
	end

	def manage
		@prize = Prize.find(params[:id])
		@prize_subcats = PrizeSubcat.search(@prize.id, params[:size], params[:color])
	end

	def prize

	end

	def new 
		@prize = Prize.find(params[:id])
		@prize_subcat = nil
	end

	def update
		@prize_subcat = PrizeSubcat.find(params[:id])
		@prize = Prize.find(@prize_subcat.prize_id)
		if(params.key?("cancel"))
        redirect_to action: :manage, id: @prize.id
    else
			if @current_user.can_manage_inventory
				if @prize_subcat.update_attributes(prize_subcat_params)
					@prize_subcat.update_attributes(image: @prize_subcat.image) if !@prize_subcat.image.blank?
					flash[:title] = 'Success'
					flash[:notice] = 'Prize type has been updated'
					StoreLog.new(:employee_id => @current_user.id, 
						:cashier_id => @current_user.id, 
						:prize_id => @prize.id,
						:prize_subcat_id => @prize_subcat.id,
						:trans => 'Updated').save
					redirect_to action: :manage, id: @prize.id
				else
					flash.now[:title] = 'Error'
					flash.now[:notice] = @prize_subcat.errors.messages
					render 'edit'
				end
			else
				flash[:title] = 'Error'
				flash[:notice] = 'You do not have permission to edit items'
				redirect_to action: :manage
			end
		end
	end

	private
		def prize_subcat_params
			params.require(:prize_subcat).permit(:id, :prize_id, :stock, :size, :color, :image, :description)
		end

end
