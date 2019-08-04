class CreatePlayerWeaponTable < ActiveRecord::Migration[5.2]
  def change
    create_table :players_weapons do |t|
      t.integer :weapon_id
      t.integer :player_id
    end
  end
end
