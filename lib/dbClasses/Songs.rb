class Song < ActiveRecord::Base
    has_many :playlistsongs
    has_many :playlists, through: :playlistsongs
end