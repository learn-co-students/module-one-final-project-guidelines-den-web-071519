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
        user_input = gets.chomp.gsub(' ', '%20')
        checker = RestClient.get("https://api.spotify.com/v1/search?q=#{user_input}&type=#{search_type}&limit=10",
                 'Authorization' => "Bearer #{GetData.access_token}")
        parsed = JSON.parse(checker)
        
        choose_playlist = CurrentUser.find_playlists($current_user.name)
        users_playlists = choose_playlist.map{|playlist| playlist.name}
        
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
            yes_or_no = prompt.select("Save this song to a playlist?", %w[Yes No])
            if yes_or_no == 'Yes'
                selected_playlist = prompt.select("Select a playlist to add this song to", users_playlists)
                current_song = display_tracks[song_index]
                CurrentUser.save_song(current_song, $current_user.name, selected_playlist)
                # Song.create(title: current_song.values[0], artist: current_song.values[1], album: current_song.values[2], year: current_song.values[3])
            end
        elsif search_type == 'artist'
            artist_results = parsed['artists']['items']
            display_artists = artist_results.map{|artist| artist['name']}
            selected_artist = prompt.select("Select an Artist", display_artists)
            artist_index = display_artists.index{|artist| artist == selected_artist}
            artist_id = artist_results[artist_index]['id']
            top_tracks_or_albums = prompt.select("View #{selected_artist}'s:'", ["Top Tracks", "Albums"])
            if top_tracks_or_albums == 'Top Tracks'
                base_url = "https://api.spotify.com/v1/"
                checker = RestClient.get("https://api.spotify.com/v1/artists/#{artist_id}/top-tracks?country=ES",
                          'Authorization' => "Bearer #{GetData.access_token}")
                top_tracks_parse = JSON.parse(checker)
                top_tracks_display = []
                top_tracks_parse['tracks'].each do |item|
                    top_tracks_hash = {title: item['name'], artist: item['artists'][0]['name'], album: item['album']['name'], year: item['album']['release_date'].first(4)}
                    top_tracks_display << top_tracks_hash
                end
                choices = top_tracks_display.map.with_index(1) do |track| 
                    "#{track[:title]} - #{track[:artist]} - #{track[:album]}"
                end
                selected_song = prompt.enum_select("Select a song or perform new search", choices)
                puts selected_song
                song_index = choices.select{|song| song == selected_song}
                yes_or_no = prompt.select("Save this song to a playlist?", %w[Yes, No])
                if yes_or_no == 'Yes'
                    
                    prompt.select("Select a playlist to add this song to", choose_playlist)
                    current_song = display_tracks[song_index]
                    CurrentUser.save_song(title: current_song.values[0], artist: current_song.values[1], album: current_song.values[2], year: current_song.values[3])
                end
            elsif top_tracks_or_albums == 'Albums'
                base_url = "https://api.spotify.com/v1/"
                checker = RestClient.get("https://api.spotify.com/v1/artists/#{artist_id}/albums/",
                        'Authorization' => "Bearer #{GetData.access_token}")
                artist_albums_parse = JSON.parse(checker)
                display_artist_albums = artist_albums_parse['items'].map{|album| album['name']}
                selected_album = prompt.select("Select an Album", display_artist_albums)
                album_index = display_artist_albums.index{|album| album == selected_album}
                album_id = artist_albums_parse['items'][album_index]['id']
                base_url = "https://api.spotify.com/v1/"
                checker = RestClient.get("https://api.spotify.com/v1/albums/#{album_id}/tracks",
                        'Authorization' => "Bearer #{GetData.access_token}")
                        album_tracks_parse = JSON.parse(checker)
                        album_tracks_display = []
                        album_tracks_parse['items'].each do |item|
                            # bindingpry
                        album_tracks_hash = {title: item['name'], artist: item['artists'][0]['name'], album: selected_album, year: artist_albums_parse['items'][album_index]['release_date'].first(4)}
                        album_tracks_display << album_tracks_hash
                end
                choices = album_tracks_display.map.with_index(1) do |track| 
                    "#{track[:title]} - #{track[:artist]} - #{track[:album]}"
                end
                selected_song = prompt.enum_select("Select a song or perform new search", choices)
                puts selected_song
                song_index = choices.select{|song| song == selected_song}
                yes_or_no = prompt.yes?("Save this song to a playlist?")
                if yes_or_no == true
                    prompt.select("Select a playlist to add this song to", )
                    current_song = display_tracks[song_index]
                    Song.create(title: current_song.values[0], artist: current_song.values[1], album: current_song.values[2], year: current_song.values[3])
                end
            end
        elsif search_type == 'album'
            display_albums = parsed['albums']['items'].map{|album| album['name']}
            album_results = parsed['albums']['items']
            display_albums = album_results.map{|album| "#{album['name']} - #{album['artists'][0]['name']}"}
            selected_album = prompt.select("Select an Album", display_albums)
            album_index = display_albums.index{|album| album == selected_album}
            album_id = album_results[album_index]['id']
            base_url = "https://api.spotify.com/v1/"
                checker = RestClient.get("https://api.spotify.com/v1/albums/#{album_id}/tracks",
                        'Authorization' => "Bearer #{GetData.access_token}")
                        album_tracks_parse = JSON.parse(checker)
                        album_tracks_display = []
                        album_tracks_parse['items'].each do |item|
                        album_tracks_hash = {title: item['name'], artist: item['artists'][0]['name'], album: selected_album, year: album_results[album_index]['release_date'].first(4)}
                        album_tracks_display << album_tracks_hash
                end
                choices = album_tracks_display.map.with_index(1) do |track| 
                    "#{track[:title]} - #{track[:artist]} - #{track[:album]}"
                end
                selected_song = prompt.enum_select("Select a song or perform new search", choices)
                puts selected_song
                song_index = choices.select{|song| song == selected_song}
                yes_or_no = prompt.yes?("Save this song to a playlist?")
                if yes_or_no == true
                    prompt.select("Select a playlist to add this song to", )
                    current_song = display_tracks[song_index]
                    Song.create(title: current_song.values[0], artist: current_song.values[1], album: current_song.values[2], year: current_song.values[3])
                end
        else
            puts "Please enter a valid command"
            self.search_any(search_type)
        end
    end
end
