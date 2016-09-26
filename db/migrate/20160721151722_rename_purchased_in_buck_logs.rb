class RenamePurchasedInBuckLogs < ActiveRecord::Migration
  def change
 	rename_column :buck_logs, :purchased, :purchase_id 
  end
end
