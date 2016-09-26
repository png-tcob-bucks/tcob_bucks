class AddFeaturedToPrizes < ActiveRecord::Migration
  def change
    add_column :prizes, :featured, :boolean, default: false
  end
end
