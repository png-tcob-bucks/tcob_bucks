class AddPurchasedToBuckLog < ActiveRecord::Migration
  def change
    add_column :buck_logs, :purchased, :int
  end
end
