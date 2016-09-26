class DeleteAllItemAtts < ActiveRecord::Migration
  def change
  	remove_column :store_logs, :item_id, :integer
  end
end
