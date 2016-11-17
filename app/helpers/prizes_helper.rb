module PrizesHelper

	def get_categories
		categories = ["Accessories",
		"Apparel",
		"Appliances",
		"Decorative",
		"Electronics",
		"Hollywood Perks",
		"Miscellaneous",
		"Tickets"]

		return categories
	end

	def get_color_code(color)
		case color
		when "Black"
			return "#000000"
		when "Blue"
			return "#0000FF"
		when "Brown"
			return "#A52A2A"
		when "Dark Brown"
			return "#0000FF"
		when "Gold"
			return "#EAC117"
		when "Grey"
			return "#808080"
		when "Green"
			return "#008000"
		when "Light Brown"
			return "#de7848"
		when "Lime Green"
			return "#00FF00"
		when "Maroon"
			return "#800000"
		when "Navy"
			return "#0000A0"
		when "Orange"
			return "#FFA500"
		when "Pink"
			return "#FF00FF"
		when "Purple"
			return "#800080"
		when "Red"
			return "#FF0000"
		when "Sky Blue"
			return "#ADD8E6"
		when "Teal"
			return "#FFFF00"
		when "White"
			return "#FFFFFF"
		when "Yellow"
			return "#FFFF00"
		end

	end

end