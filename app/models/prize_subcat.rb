class PrizeSubcat < ActiveRecord::Base

	belongs_to :prize

	def self.search(id, size, color, brand)
	    if color || size || brand
	      PrizeSubcat.where('prize_id LIKE ?
	        AND size LIKE ?
	        AND color LIKE ?
	        AND brand LIKE ?', "%#{id}%", "%#{size}%", "%#{color}%", "%#{brand}%")
	    else
	      	PrizeSubcat.where(prize_id: id)
	    end
	end


end
