class PrizeSubcat < ActiveRecord::Base

	belongs_to :prize

	def self.search(prize_id, size, color, brand)
	    if color || size || brand 
	      PrizeSubcat.where(prize_id: prize_id, size: size, color: color)
	    else
	      PrizeSubcat.where(prize_id: prize_id)
	    end
	end

	def self.search_store(id, size, color, brand)
	    if color || size || brand 
	    where(prize_id: prize_id).
	      where('id LIKE ?
	        AND size LIKE ?
	        AND color LIKE ?
	        AND brand LIKE ?', "%#{id}%", "%#{size}%", "%#{color}%", "%#{brand}%")
	    else
	      PrizeSubcat.where(prize_id: id)
	    end
  	end

end
