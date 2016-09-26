class DepartmentBudgetDefaultTo0 < ActiveRecord::Migration
  def change
  	change_column :departments, :budget, :integer, :default => 0
  end
end
