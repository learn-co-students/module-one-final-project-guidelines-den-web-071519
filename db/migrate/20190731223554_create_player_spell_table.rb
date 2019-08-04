class CreatePlayerSpellTable < ActiveRecord::Migration[5.2]
  def change
    create_table :players_spells do |t|
      t.integer :spell_id
      t.integer :player_id
    end
  end
end
