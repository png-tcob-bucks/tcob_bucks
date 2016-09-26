class AddBudgetAttrsToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :balance, :integer, default: 0, index: true
  	add_column :employees, :earned_m, :integer, default: 0, index: true
  end
end
