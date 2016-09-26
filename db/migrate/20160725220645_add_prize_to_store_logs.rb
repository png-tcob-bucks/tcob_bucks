class AddPrizeToStoreLogs < ActiveRecord::Migration
  def change
  	add_reference :store_logs, :prize, foreign_key: true, index: true, null: true
  end
end
