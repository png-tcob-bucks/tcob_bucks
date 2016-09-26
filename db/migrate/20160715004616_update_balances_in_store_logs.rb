class UpdateBalancesInStoreLogs < ActiveRecord::Migration
  def change
  	change_column :store_logs, :balance_before, :integer, null: true
  	change_column :store_logs, :balance_after, :integer, null: true
  end
end
