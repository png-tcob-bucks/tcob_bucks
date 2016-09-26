class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
    	t.string		:jobcode, null: false
    	t.string 		:title, null: false

      t.timestamps null: false
    end
  end
end
