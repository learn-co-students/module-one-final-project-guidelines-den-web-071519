class Playlist < ActiveRecord::Base
    belongs_to :user
    has_many :playlistsongs
    has_many :songs, through: :playlistsongs
end