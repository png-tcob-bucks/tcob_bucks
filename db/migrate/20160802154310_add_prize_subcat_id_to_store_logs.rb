class AddPrizeSubcatIdToStoreLogs < ActiveRecord::Migration
  def change
  	add_column :store_logs, :prize_subcat_id, :integer
  end
end
