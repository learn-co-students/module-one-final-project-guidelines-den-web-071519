require 'rest-client'
require 'json'
require 'pry'

class CurrentUser
    
    def self.find_playlists id
     Playlist.where(id: id)
    end

    def self.create_playlist id, name
        Playlist.create(id: id, name: name)
    end

    def self.playlist_songs playlist_id
        Song.where(playlist_id: playlist_id)
    end

    def self.delete_playlist playlist_id
        Playlist.where(id: playlist_id).destroy_all
        Song.where(playlist_id: playlist_id).destroy_all
    end

    def self.delete_song playlist_id, song
        delSong = Song.where(playlist_id: playlist_id, title: song).first
        delSong.destroy
    end

end



# puts CurrentUser.find_playlists 0
