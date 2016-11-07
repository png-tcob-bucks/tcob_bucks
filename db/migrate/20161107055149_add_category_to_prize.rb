class AddCategoryToPrize < ActiveRecord::Migration
  def change
    add_column :prizes, :category, :string, null: true
  end
end
