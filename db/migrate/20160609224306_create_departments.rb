class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
    	t.string 	:code, null: false, unique: true
    	t.string 	:name, code: false, unique: true
    end
  end
end
