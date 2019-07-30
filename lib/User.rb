require 'rest-client'
require 'json'
require 'pry'

class Search
    attr_accessor :name, :playlists, :token

    def initialize name
        @name = name
        # @token = GetData.access_token
    end

    def search_any search_type
        base_url = 'https://api.spotify.com/v1/'
        newUrl = base_url + 'search'
        puts "Enter a #{search_type}."
        user_input = gets.chomp.gsub(' ', '%20')
        checker = RestClient.get("https://api.spotify.com/v1/search?q=#{user_input}&type=#{search_type}&limit=10",
                 'Authorization' => "Bearer #{GetData.access_token}")
        parsed = JSON.parse(checker)
        
        if search_type == 'track'
            display_tracks = []
            parsed['tracks']['items'].each_with_index do |item|
                tracks_hash = {title: item['name'], artist: item['artists'][0]['name'], album: item['album']['name']}
                display_tracks << tracks_hash
            end
            display_tracks
        elsif search_type == 'artist'
            display_artists = parsed['artists']['items'].map{|artist| artist['name']}
            display_artists
                
        elsif search_type == 'album'
            display_albums = parsed['albums']['items'].map{|album| album['name']}
        else
            puts "Please enter a valid command"
            self.search_any(search_type)
        end
    end

end
