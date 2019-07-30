class CreateSongPlaylistsJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :playlistsongs do |t|
      t.references :song, foreign_key: true
      t.references :playlist, foreign_key: true 
    end
  end
end
