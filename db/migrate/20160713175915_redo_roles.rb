class RedoRoles < ActiveRecord::Migration
  def change
  	rename_column :roles, :pay, :issue
  	rename_column :roles, :void, :redeem
  	rename_column :roles, :edit, :admin
  	add_column :roles, :issue_gold, :boolean, default: 0, null: false
  end
end
