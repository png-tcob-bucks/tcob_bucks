class AddBudgetToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :budget, :int
  end
end
