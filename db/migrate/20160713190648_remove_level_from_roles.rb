class RemoveLevelFromRoles < ActiveRecord::Migration
  def change
  	remove_column :roles, :level, :integer
  end
end
