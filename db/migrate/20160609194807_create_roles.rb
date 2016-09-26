class CreateRoles < ActiveRecord::Migration
  def change
    create_table :role do |t|
    	t.string	:title, null: false
    	t.boolean :pay
    	t.boolean :approve
    	t.boolean	:void
			t.boolean	:edit
    	t.boolean	:view_all
    end
  end
end