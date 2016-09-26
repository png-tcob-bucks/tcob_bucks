class AddRecieveToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :recieve, :boolean
  end
end
