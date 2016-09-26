class RenameBeforeAfterInStoreLogs < ActiveRecord::Migration
  def change
  	rename_column :store_logs, :balance_before, :stock_before
  	rename_column :store_logs, :balance_after, :stock_after
  end
end
