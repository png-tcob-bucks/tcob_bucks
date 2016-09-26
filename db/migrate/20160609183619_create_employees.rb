class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
    	t.integer      :IDnum, index: true, unique: true, null: false
    	t.string       :first_name, index: true
    	t.string       :last_name, index: true
    	t.belongs_to   :role, index: true, null: false
    	t.belongs_to	 :department, null: false
      t.timestamps   null: false
    end
  end
end
