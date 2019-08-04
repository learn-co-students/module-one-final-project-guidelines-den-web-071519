class AddHealthToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :health, :integer, default: 100, null: false
  end
end
