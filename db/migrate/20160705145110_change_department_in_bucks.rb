class ChangeDepartmentInBucks < ActiveRecord::Migration
  def change
  	change_column :bucks, :department, :integer
  	rename_column :bucks, :department, :department_id
  end
end
