class AddFeedBackToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :feedback, :boolean, default: false
  end
end
