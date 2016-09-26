class AddPrizeSubcatIdToPurchases < ActiveRecord::Migration
  def change
  	add_column :purchases, :prize_subcat_id, :integer
  end
end
