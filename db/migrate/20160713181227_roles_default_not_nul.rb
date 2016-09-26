class RolesDefaultNotNul < ActiveRecord::Migration
  def change
  	change_column :roles, :issue, :boolean, default: false, null: false
  	change_column :roles, :approve, :boolean, default: false, null: false
  	change_column :roles, :redeem, :boolean, default: false, null: false
  	change_column :roles, :admin, :boolean, default: false, null: false
  	change_column :roles, :view_all, :boolean, default: false, null: false
  	change_column :roles, :recieve, :boolean, default: false, null: false
  	change_column :roles, :view_dept, :boolean, default: false, null: false
  	change_column :roles, :level, :integer, default: 1, null: false
  end
end
