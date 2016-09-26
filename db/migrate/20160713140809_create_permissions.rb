class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
    	t.belongs_to	:job, index: true, null: false
    	t.belongs_to 	:role, index: true, null: false
      t.timestamps null: false
    end
  end
end
