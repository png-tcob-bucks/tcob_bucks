module FavoritesHelper

	def progress_color(balance, cost)
		if balance < (cost / 2)
			return "text-red"
		elsif balance >= cost
			return "text-green"
		else
			return "text-yellow"
		end
	end

	def item_progress(user_bucks, cost)
		return (cost / user_bucks) * 100
	end

end
