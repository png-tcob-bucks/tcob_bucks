class AddItemIdToPrizes < ActiveRecord::Migration
  def change
    add_column :prizes, :itemID, :string, :null => false

    add_index :prizes, ["id", "itemID"], :unique => true
  end
end
