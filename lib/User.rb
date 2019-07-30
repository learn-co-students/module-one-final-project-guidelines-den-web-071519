require 'rest-client'
require 'json'
require 'pry'

class User
    extend GetData
    attr_accessor :name, :playlists, :token
    def initialize name
        @name = name
        @token = GetData.access_token
    end

    def search_any search_type
        base_url = 'https://api.spotify.com/v1/'
        newUrl = base_url + 'search'
        puts "Hey #{self.name}! Enter a #{search_type}."
        user_input = gets.chomp.gsub(' ', '%20')
        checker = RestClient.get("https://api.spotify.com/v1/search?q=#{user_input}&type=#{search_type}&limit=10",
                 'Authorization' => "Bearer #{self.token}")
        parsed = JSON.parse(checker)
        
        if search_type == 'track'
            display_track = {}
            display_tracks = []
            display_track[:title] = nil
            display_track[:artist] = nil
            display_track[:album] = nil
            parsed['tracks']['items'].map do |item|
                binding.pry
                display_track[:title] = item['name']
                display_track[:artist] = item['artists'][0]['name']
                display_track[:album] = item['album']['name']
                display_tracks << display_track
                end
            end
            display_tracks
            
        elsif search_type == 'artist'
            display_artists = parsed['artists']['items'].map{|artist| artist['name']}
            display_artists
                
        elsif search_type == 'album'
            display_albums = parsed['albums']['items'].map{|album| album['name']}
        else
            puts "Please enter a valid command"
        end
    end

end
