require 'rest-client'
require 'json'
require 'pry'

class CurrentUser
    def self.find_playlists name
        inputId = User.where(name: name).first.id 
        Playlist.where(user_id: inputId)
    end
    
    def self.get_playlist_id username, playlistName
        userId = User.where(name: username).first.id 
        Playlist.where(name: playlistName).where(user_id: userId)
    end

    def self.find_playlist_id name #need to take this one out, use the one above if you need a playlist id^
        Playlist.where(name: name).first.id
    end

    def self.make_user name
        User.create(name: name)
        userId = User.where(name: name).first.id
        CurrentUser.create_playlist(name, 'Default Playlist')
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

    def self.find_songs username, playlistName #finds songs in a playlist
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        Playlistsong.where(playlist_id: playlistId)
    end
  
    def self.delete_playlist username, playlistName
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        Playlist.where(id: playlistId).destroy_all
    end

    def self.delete_playlist_songs username, playlistName
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        Playlistsong.where(playlist_id: playlistId).destroy_all
    end
end

    def self.delete_playlist username, playlistName #deletes playlist and songs
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        CurrentUser.delete_playlist_songs(username, playlistName)
        Playlist.where(id: playlistId).destroy_all   
    end

    def self.delete_playlist_songs username, playlistName #deletes all songs from a playlist (but leaves playlist)
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        Playlistsong.where(playlist_id: playlistId).destroy_all
    end
    
    def self.delete_specific_song username, playlistName, songTitle
        songId = Song.where(title: songTitle).first.id
        playlistId = CurrentUser.get_playlist_id(username, playlistName)
        if songId != nil
            Playlistsong.where(playlist_id: playlistId).where(song_id: songId).destroy_all
        end
    end

    def self.delete_user username
        playlistArray = []
        CurrentUser.find_playlists(username).each_with_index do |value, index|
            playlistArray << CurrentUser.find_playlists('bob')[index].name
        end
        playlistArray.each do |playlist|
            CurrentUser.delete_playlist(username, playlist)
        end
        User.where(name: username).destroy_all
    end
    
end
