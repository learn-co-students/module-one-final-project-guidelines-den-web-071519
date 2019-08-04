class AddLevelToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :level, :integer, default: 0, null: false
  end
end
