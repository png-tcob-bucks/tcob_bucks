class RenameBuckLogColumns < ActiveRecord::Migration
  def change
  	rename_column :buck_logs, :by, :performed_id
  	rename_column :buck_logs, :to, :recieved_id
  end
end
