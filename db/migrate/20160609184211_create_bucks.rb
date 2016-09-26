class CreateBucks < ActiveRecord::Migration
  def change
    create_table :bucks do |t|
    	t.integer 			:number, index: true, unique: true, null: false
    	t.belongs_to 		:employee, index: true, null: false
    	t.integer				:value, null: false
      t.string 				:status
      t.integer				:assignedBy, index: true
      t.string 				:department, null: false
      t.string				:reason_short
      t.text					:reason_long
      t.datetime 			:expires
      t.timestamps 		null: false
    end
  end
end
