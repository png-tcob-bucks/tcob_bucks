class AddReturnedToPurchases < ActiveRecord::Migration
  def change
  	add_column :purchases, :returned, :boolean, default: false
  end
end
