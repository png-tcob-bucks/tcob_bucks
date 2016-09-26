class MakeAssignedByNotNull < ActiveRecord::Migration
  def change
  	change_column_null :bucks, :assignedBy, false 
  end
end
