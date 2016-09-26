class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
    	t.belongs_to 				:employee, null: false, index: true
    	t.references				:prize, null: false, index: true
      t.timestamps 				null: false
    end
  end
end
