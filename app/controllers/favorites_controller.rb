class FavoritesController < ApplicationController
	include SessionsHelper
	include EmployeesHelper
	include FavoritesHelper

	before_filter :authenticate_user_logged_in

	def analyze

	end

	def create
		flash[:title] = 'Success'
		if Favorite.find_by(employee_id: @current_user, prize_id: params[:id]).blank?
			Favorite.create(employee_id: @current_user.id, prize_id: params[:id]).save
			flash[:notice] = Prize.find(params[:id]).name + 'Prize was added to your favorites!'
		else
			flash[:notice] = Prize.find(params[:id]).name + ' is already in your favorites!'
		end
		redirect_to action: :index
	end

	def delete

	end

	def index
		@favorites = @current_user.favorites
		@balance = @current_user.get_bucks_balance
	end

	def new

	end

end
