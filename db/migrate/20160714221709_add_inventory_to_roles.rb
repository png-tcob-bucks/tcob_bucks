class AddInventoryToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :inventory, :boolean, default: false, null: false
  end
end
