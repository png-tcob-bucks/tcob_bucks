class AddEmailToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :email, :string, null: true
  end
end
