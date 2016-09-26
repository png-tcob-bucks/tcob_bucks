class RenameTableRole < ActiveRecord::Migration
  def change
  	rename_table :role, :roles
  end
end
