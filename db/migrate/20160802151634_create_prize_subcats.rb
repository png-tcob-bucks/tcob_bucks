class CreatePrizeSubcats < ActiveRecord::Migration
  def change
    create_table :prize_subcats do |t|
    t.references 				:prize, null: false, index: true
  	t.integer 					:stock, default: 0
  	t.datetime					:last_counted
  	t.string						:size
  	t.string 						:color
  	t.text							:image
    t.timestamps 				null: false
    end
  end
end
