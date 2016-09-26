class NullPurchaseIdInStoreLogs < ActiveRecord::Migration
  def change
  	change_column :store_logs, :purchase_id, :integer, null: true
  end
end
