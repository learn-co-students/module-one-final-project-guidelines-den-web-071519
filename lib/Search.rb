require 'rest-client'
require 'json'
require 'pry'

class Search

    def self.search_menu
        prompt = TTY::Prompt.new
        choices = ["Search Song", "Search Artists", "Search Albums"]
        search_select = prompt.select("What would you like to search for?", choices)
        if search_select == 'Search Song'
            Search.search_any('track')
        elsif search_select == 'Search Artists'
            Search.search_any('artist')
        elsif search_select == 'Search Albums'
            Search.search_any('album')
        end
    end

    def self.search_any search_type
        prompt = TTY::Prompt.new
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
            choices = display_tracks.map.with_index(1) do |track| 
                "#{track[:title]} - #{track[:artist]} - #{track[:album]}"
            end
            selected_song = prompt.enum_select("Select a song or perform new search", choices)
            puts selected_song
            song_index = choices.index{|song| song == selected_song}
            yes_or_no = prompt.yes?("Save this song to a playlist?")
            if yes_or_no == true
                current_song = display_tracks[song_index]
                # binding.pry
                Song.create(title: current_song.values[0], artist: current_song.values[1], album: current_song.values[2], year: current_song.values[3])
            end
            binding.pry
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
