class SplitPrizeForSubcat < ActiveRecord::Migration
  def change
  	remove_column :prizes, :stock, :integer
  	remove_column :prizes, :last_counted, :datetime
  	remove_column :prizes, :size, :string
  	remove_column :prizes, :color, :string
  end
end
