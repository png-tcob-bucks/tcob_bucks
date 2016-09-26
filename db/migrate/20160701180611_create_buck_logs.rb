class CreateBuckLogs < ActiveRecord::Migration
  def change
    create_table :buck_logs do |t|
    	t.integer 		  :buck_id, index: true, null: false
    	t.string				:event, null: false
      t.integer 			:by, index: true, null: false
      t.integer				:to, index: true, null: false
      t.string 				:status_before, null: false
      t.string 				:status_after, null: false
      t.integer				:value_before
      t.integer				:value_after
      t.timestamps 		null: false
    end
  end
end
