class SetDefaultPrizeImage < ActiveRecord::Migration
  def change
  	change_column :prizes, :image, :string, default: '/images/no_image.png'
  end
end
