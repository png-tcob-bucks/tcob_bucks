class RecreateFavoritesInterdependency < ActiveRecord::Migration
  def change
  	drop_table :favorites

    create_table :favorites do |t|
    	t.belongs_to 				:employee, null: false, index: true
    	t.belongs_to				:prize, null: false, index: true
      t.timestamps 				null: false
    end
  end
end
