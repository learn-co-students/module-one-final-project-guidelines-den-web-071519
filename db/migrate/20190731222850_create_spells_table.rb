class CreateSpellsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :spells do |t|
      t.string :name
      t.integer :health
      t.integer :damage
    end
  end
end
