class Song < ActiveRecord::Base
    def save_song title, artist, album, genre, year, playlist_id
        Song.create(title: title,
                    artist: artist, 
                    album: album, 
                    genre: genre, 
                    year: year)
    end
end