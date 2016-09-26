class AddStockBarcodeToPrizes < ActiveRecord::Migration
  def change
    add_column :prizes, :stock, :integer, default: 0
    add_column :prizes, :barcode, :string
    add_column :prizes, :last_counted, :datetime
  end
end
