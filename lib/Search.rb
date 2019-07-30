require 'rest-client'
require 'json'
require 'pry'

class Search

    def self.search_menu
        puts "What would you like to search for?"
        puts "1. Search Song"
        puts "2. Search Artist"
        puts "3. Search Album"
        input = gets.chomp
        if input == '1'
            Search.search_any('track')
        elsif input == '2'
            Search.search_any('artist')
        elsif input == '3'
            Search.search_any('album')
        else
            puts "Enter a valid command."
            search_menu
        end
    
    end

    def self.search_any search_type
        base_url = 'https://api.spotify.com/v1/'
        newUrl = base_url + 'search'
        puts "Enter a #{search_type}."
        user_input = gets.chomp.gsub(' ', '%20')
        checker = RestClient.get("https://api.spotify.com/v1/search?q=#{user_input}&type=#{search_type}&limit=10",
                 'Authorization' => "Bearer #{GetData.access_token}")
        parsed = JSON.parse(checker)
        
        if search_type == 'track'
            display_tracks = []
            parsed['tracks']['items'].each do |item|
                tracks_hash = {title: item['name'], artist: item['artists'][0]['name'], album: item['album']['name'], year: item['album']['release_date'].first(4)}
                display_tracks << tracks_hash
            end
            display_tracks.each_with_index do |track, index| 
                puts "#{index + 1}. #{track[:title]} - #{track[:artist]} - #{track[:album]}"
            end
            puts "Select a song or perform new search"
            song_select = gets.chomp
            selected_song = display_tracks[song_select.to_i]
            puts "#{selected_song[:title]} - #{selected_song[:artist]}"
            #add song saver method here !!!
            # binding.pry
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
