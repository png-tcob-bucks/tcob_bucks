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

end
