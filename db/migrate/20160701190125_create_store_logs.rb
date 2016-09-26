class CreateStoreLogs < ActiveRecord::Migration
  def change
    create_table :store_logs do |t|
    	t.integer 		  :employee_id, index: true, null: false
    	t.string				:cashier_id, index: true, null: false
      t.integer 			:item_id, index: true, null: false
      t.integer				:balance_before, null: false
      t.string 				:balance_after, null: false
      t.string        :transaction
      t.timestamps	 null: false
    end
  end
end
