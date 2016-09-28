class AddApproversToDepartments < ActiveRecord::Migration
  def change
  	add_column :departments, :approve1, :string, null: true
  	add_column :departments, :approve2, :string, null: true
  end
end
