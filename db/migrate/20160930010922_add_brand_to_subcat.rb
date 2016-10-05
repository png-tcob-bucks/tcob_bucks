class AddBrandToSubcat < ActiveRecord::Migration
  def change
  	add_column :prize_subcats, :brand, :string
  end
end
