class ChangeJobIdInPermissions < ActiveRecord::Migration
  def change
  	change_column :permissions, :job_id, :string
  end
end
