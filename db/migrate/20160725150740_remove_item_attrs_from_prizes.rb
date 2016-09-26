class RemoveItemAttrsFromPrizes < ActiveRecord::Migration
  def change
  	remove_column :prizes, :itemID, :string
  	remove_column :prizes, :barcode, :string
  end
end
