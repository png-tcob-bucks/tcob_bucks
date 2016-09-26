class BuckLog < ActiveRecord::Base

	def self.search(buck_id, performed_id, recieved_id)
    if buck_id || performed_id || recieved_id
      where('buck_id LIKE ? 
        AND performed_id LIKE ? 
        AND recieved_id LIKE ?', "%#{buck_id}%", "%#{performed_id}%", "%#{recieved_id}%")
    end
  end

end
