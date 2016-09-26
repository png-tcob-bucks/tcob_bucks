class AddAttributesToPrizes < ActiveRecord::Migration
  def change
  	add_column :prizes, :size, :string
  	add_column :prizes, :color, :string
  	change_column :prizes, :description, :text
  	add_column :prizes, :image, :text
  end
end