class CreateSavedProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_profiles do |t|
      t.string :name
      t.string :bio
      t.string :password
      t.integer :level, default: 1, null: false
    end
  end
end
