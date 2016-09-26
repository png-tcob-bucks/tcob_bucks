class SwitchQtyWithDescPrices < ActiveRecord::Migration
  def change
  	remove_column :prizes, :quantity
  	add_column :prizes, :description, :string
  end
end
