class Playlistsong < ActiveRecord::Base
    belongs_to :playlist
    belongs_to :song
end