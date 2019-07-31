require 'rest-client'
require 'json'
require 'pry'

class CurrentUser
    def self.find_playlists name
        inputId = User.where(name: name).first.id 
        Playlist.where(user_id: inputId).first.id
    end
    
    def self.get_playlist_id username, playlistName
        userId = User.where(name: username).first.id 
        Playlist.where(name: playlistName).where(user_id: userId)
    end

    def self.find_playlist_id name
        Playlist.where(name: name).first.id
    end

    def self.create_playlist username, playlistName
        inputId = User.where(name: username).first.id
        if Playlist.where(user_id: inputId).where(name: playlistName).count == 0
            Playlist.create(user_id: inputId, name: playlistName)
        else 
            "A playlist of that name already exists, please choose a different name or delete this playlist first."
        end
    end

    def self.save_song h, username, playlistName # takes in hash, username, playlistName
        song = Song.create(title: h[:title], artist: h[:artist], album: h[:album], genre: h[:genre], year: h[:year]) #adds songs, attr values nil by default
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        Playlistsong.create(song_id: song.id, playlist_id: playlistId)
    end

    def self.find_songs username, playlistName
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        Playlistsong.where(playlist_id: playlistId)
    end
end

