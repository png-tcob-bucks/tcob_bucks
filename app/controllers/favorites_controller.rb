class FavoritesController < ApplicationController
	include SessionsHelper
	include EmployeesHelper
	include FavoritesHelper

	before_filter :authenticate_user_logged_in

	def analyze

	end

	def create
		flash[:title] = 'Success'

		if Favorite.find_by(employee_id: @current_user, prize_id: params[:prize_id]).blank?
			Favorite.create(employee_id: @current_user.id, prize_id: params[:prize_id]).save
			flash[:notice] = Prize.find(params[:prize_id]).name + ' was added to your favorites!'
		else
			flash[:notice] = Prize.find(params[:prize_id]).name + ' is already in your favorites!'
		end
		redirect_to controller: :prizes, action: :show, id: params[:prize_id]
	end

	def delete
		Favorite.find_by(employee_id: @current_user.id, prize_id: params[:prize_id]).delete
		if params[:source] == 'shop'
			flash[:title] = 'Success'
			flash[:notice] = Prize.find(params[:prize_id]).name + ' has been removed from your favorites.'
			redirect_to controller: :prizes, action: :show, id: params[:prize_id]
		else
			flash[:title] = 'Success'
			flash[:notice] = Prize.find(params[:prize_id]).name + ' has been removed from your favorites.'
			redirect_to controller: :favorites, action: :index
		end
	end

	def index
		@favorites = @current_user.favorites
		@balance = @current_user.get_bucks_balance
	end

	def new

	end

end
