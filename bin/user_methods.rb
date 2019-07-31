require_relative '../config/environment'
require 'pry'
require 'tty-prompt'

current_user = nil
def create_user
    puts "Enter your User Name."
    input = gets.chomp
    $current_user = CurrentUser.make_user(input)
    user_menu($current_user)
end

def log_in
    prompt = TTY::Prompt.new
        puts "Select a user to log into"
        choices = User.all.map{|user| user.name}
        select_user = prompt.select("Select a user to log in", choices)
        $current_user = User.find_by(name: select_user)
        user_menu($current_user)
    end
    
    def welcome
        prompt = TTY::Prompt.new
        menu_select = prompt.select("Welcome to Playlister!", %w(Log-in Create-User))
        if menu_select == 'Log-in'
            log_in
        elsif menu_select == 'Create-User'
            $current_user = create_user
        end
    end

    def view_playlists (current_user)
        # binding.pry
        prompt = TTY::Prompt.new
        user = User.where(name: current_user.name).first
        current_playlists = user.playlists
        
        selected = prompt.select("Select a playlist", current_playlists.map{|playlist| playlist.name})
        playlist_songs = Playlist.where(name: selected).where(user_id: current_user.id).first.songs
        choices = playlist_songs.map{|song| song.title}
        # selected_playlist_id = Playlist.where(user_id: current_user.id).where(name: selected).first.id
        # playlist_songs = Playlistsong.where(playlist_id: selected_playlist_id)
        # choices = playlist_songs.map{|song| song.name}
        binding.pry
    end

    def user_menu (current_user)
        prompt = TTY::Prompt.new
        puts "Welcome, #{current_user.name}"
        choices = ["View Playlists", "Create Playlist", "Delete Playlist", "Search For Songs", "Log-out"]
        user_menu_select = prompt.select("What would you like to do?", choices)
      
        loop do
            case user_menu_select
                when 'View Playlists'
                    view_playlists ($current_user)
                when 'Create Playlist'
                    puts "What would you like to call this playlist?"
                    playlist_name = gets.chomp
                    CurrentUser.create_playlist(current_user.id, playlist_name)
                when 'Delete Playlist'
                    user = User.where(name: current_user.name)
                    choices = user.playlists.map{|playlist| playlist.name}
                    playlist_select = prompt.select("Which Playlist would you like to delete?", choices)           
                    #CurrentUser.delete_playlist(CurrentUser.find_playlist_id (playlist_select))
                when 'Search For Songs'
                    Search.search_menu
                when 'Log-out'
                    welcome
            end
        end
    end

    welcome

    binding.pry