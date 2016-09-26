class RenameMustReserveToMustOrderInPrizes < ActiveRecord::Migration
  def change
  	rename_column :prizes, :must_reserve, :must_order
  end
end
