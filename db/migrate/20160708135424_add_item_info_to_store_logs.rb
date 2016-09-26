class AddItemInfoToStoreLogs < ActiveRecord::Migration
  def change
  	add_reference :store_logs, :prize, foreign_key: true, index: true, null: false
  end
end
