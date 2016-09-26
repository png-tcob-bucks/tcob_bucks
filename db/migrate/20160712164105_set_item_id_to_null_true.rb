class SetItemIdToNullTrue < ActiveRecord::Migration
  def change
  	change_column :store_logs, :item_id, :integer, null: true
  end
end
