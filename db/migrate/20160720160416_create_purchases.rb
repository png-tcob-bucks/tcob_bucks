class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
    	t.integer			:prize_id, null: false, index: true
    	t.integer			:employee_id
    	t.integer			:cashier_id
    	t.string 			:status
    	t.boolean			:exchanged, default: false 
      t.timestamps null: false
    end
  end
end
