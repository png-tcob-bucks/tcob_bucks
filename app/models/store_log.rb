class StoreLog < ActiveRecord::Base

	def self.search(customer_id, cashier_id, item_barcode)
    if customer_id || cashier_id || item_barcode
      where('employee_id LIKE ? 
        AND cashier_id LIKE ?', "%#{customer_id}%", "%#{cashier_id}%")
    end
  end

end
