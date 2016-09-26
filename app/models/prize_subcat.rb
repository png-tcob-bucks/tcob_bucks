class PrizeSubcat < ActiveRecord::Base

	belongs_to :prize

	def self.search(prize_id, size, color)
    if color || name 
      where(prize_id: prize_id).
      where('size LIKE ?
        AND color LIKE ?', "%#{size}%", "%#{color}%")
    else
      PrizeSubcat.where(prize_id: prize_id)
    end
  end

end
