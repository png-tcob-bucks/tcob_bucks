class ChangeJobIdInEmployees < ActiveRecord::Migration
  def change
  	change_column :employees, :job_id, :string
  end
end
