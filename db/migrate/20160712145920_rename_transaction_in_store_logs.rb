class RenameTransactionInStoreLogs < ActiveRecord::Migration
  def change
  	rename_column :store_logs, :transaction, :trans
  end
end
