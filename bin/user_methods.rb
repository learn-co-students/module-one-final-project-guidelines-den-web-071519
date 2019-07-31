require_relative '../config/environment'
require 'pry'
require 'tty-prompt'
current_user = nil
def create_user
    puts "Enter your User Name."
    input = gets.chomp
    User.make_user(input)
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
        prompt = TTY::Prompt.new
        current_playlists = CurrentUser.find_playlists(current_user.id)
        
        selected = prompt.select("Select a playlist", current_playlists.map{|playlist| playlist.name})
        # binding.pry
    end

    def user_menu (current_user)
        prompt = TTY::Prompt.new
        puts "Welcome, #{current_user.name}"
        choices = ["View Playlists", "Create Playlist", "Delete Playlist", "Search For Songs", "Log-out"]
        user_menu_select = prompt.select("What would you like to do?", choices)
        if user_menu_select == 'View Playlists'
            view_playlists (current_user)
        elsif user_menu_select == 'Create Playlist'
            puts "What would you like to call this playlist?"
            playlist_name = gets.chomp
            CurrentUser.create_playlist(current_user.id, playlist_name)
        elsif user_menu_select == 'Delete Playlist'
            choices = CurrentUser.find_playlists(current_user.id).map{|playlist| playlist.name}
            playlist_select = prompt.select("Which Playlist would you like to delete?", choices)           
            CurrentUser.delete_playlist(CurrentUser.find_playlist_id (playlist_select))
        elsif user_menu_select == 'Search For Songs'
            Search.search_menu
        elsif input == '4'
            welcome
        end

    end

    # welcome

    binding.pry