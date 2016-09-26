class AddAvailableToPrize < ActiveRecord::Migration
  def change
    add_column :prizes, :available, :boolean, null: false, default: true
  end
end
