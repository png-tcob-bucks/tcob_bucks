class AddViewDepartmentToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :view_dept, :boolean, :default => false
  end
end
