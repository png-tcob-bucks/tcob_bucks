class AddAccessToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :access, :boolean, default: false
  end
end
