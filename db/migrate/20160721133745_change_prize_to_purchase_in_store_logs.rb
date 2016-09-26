class ChangePrizeToPurchaseInStoreLogs < ActiveRecord::Migration
  def change
  	remove_foreign_key :store_logs, :prize
  	remove_reference :store_logs, :prize, index: true
  	add_reference :store_logs, :purchase, foreign_key: true, index: true, null: false
  end
end
