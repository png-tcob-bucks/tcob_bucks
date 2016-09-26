class AddMustReserveToPrizes < ActiveRecord::Migration
  def change
    add_column :prizes, :must_reserve, :boolean
  end
end
