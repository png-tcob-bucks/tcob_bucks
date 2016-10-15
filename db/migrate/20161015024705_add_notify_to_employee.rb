class AddNotifyToEmployee < ActiveRecord::Migration
  def change
  	add_column :employees, :notify, :boolean, default: true
  end
end
