class AddApprovedAtToBucks < ActiveRecord::Migration
  def change
    add_column :bucks, :approved_at, :datetime
  end
end
