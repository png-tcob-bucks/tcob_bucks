class AddJobcodeToEmployees < ActiveRecord::Migration
  def change
  	remove_column :employees, :role_id, :integer
  	add_reference :employees, :job, index: true, null: false
  end
end
