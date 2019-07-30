require 'rest-client'
require 'json'
require 'pry'

class CurrentUser
    
    def self.find_playlists id
     Playlist.where(user_id: id)
    end

    def self.find_playlist_id name
        Playlist.where(name: name).first.id
    end

    def self.create_playlist id, name

        Playlist.create(user_id: id, name: name)

        if Playlist.where(name: name).count == 0
            Playlist.create(user_id: id, name: name)
           return "Created Playlist: #{name}"
        end
        "Failed to create playlist, playlist of that name already exists."

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

