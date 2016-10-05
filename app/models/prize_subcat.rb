class PrizeSubcat < ActiveRecord::Base

	belongs_to :prize

	def self.search(prize_id, size, color, brand)
    if color || name 
      where(prize_id: prize_id, size: size, color: color, brand: brand)
    else
      PrizeSubcat.where(prize_id: prize_id)
    end
  end

end
