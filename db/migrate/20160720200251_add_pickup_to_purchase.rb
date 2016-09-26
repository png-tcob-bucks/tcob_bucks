class AddPickupToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :pickedup_by, :integer, index: true, null: true
  end
end
