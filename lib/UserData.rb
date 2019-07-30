require 'rest-client'
require 'json'
require 'pry'
require_relative '../config/environment'

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


end



# puts CurrentUser.find_playlists 0

# binding.pry